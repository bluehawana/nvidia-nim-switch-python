"""Telegram messaging platform for NVIDIA NIM Proxy."""

import asyncio
import logging
from typing import Callable, Optional

from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters
from telegram.constants import ParseMode

logger = logging.getLogger(__name__)


class TelegramPlatform:
    """Telegram messaging platform."""

    def __init__(self, bot_token: str, allowed_user_id: Optional[str] = None):
        """Initialize the Telegram platform.

        Args:
            bot_token: Telegram bot token
            allowed_user_id: Optional user ID to restrict access
        """
        self.bot_token = bot_token
        self.allowed_user_id = allowed_user_id
        self.application: Optional[Application] = None
        self.message_handler: Optional[Callable] = None
        self.is_running = False

    def on_message(self, handler: Callable):
        """Register a message handler.

        Args:
            handler: Function to handle incoming messages
        """
        self.message_handler = handler

    async def start(self):
        """Start the Telegram bot."""
        if self.is_running:
            logger.warning("Telegram bot is already running")
            return

        try:
            self.application = (
                Application.builder().token(self.bot_token).build()
            )

            # Register command handlers
            self.application.add_handler(CommandHandler("start", self._start_command))
            self.application.add_handler(CommandHandler("help", self._help_command))
            self.application.add_handler(CommandHandler("status", self._status_command))

            # Register message handler
            self.application.add_handler(
                MessageHandler(filters.TEXT & ~filters.COMMAND, self._handle_message)
            )

            # Start the bot
            await self.application.initialize()
            await self.application.start()

            # Send startup notification
            async with self.application.get_bot().conversation() as bot:
                target = self.allowed_user_id or (await bot.get_me()).id
                await bot.send_message(
                    target, "🚀 **NVIDIA NIM Proxy is online!** (Bot API)"
                )

            # Run in background
            self.is_running = True
            logger.info("Telegram bot started successfully")

        except Exception as e:
            logger.error(f"Failed to start Telegram bot: {e}")
            raise

    async def stop(self):
        """Stop the Telegram bot."""
        if not self.is_running or not self.application:
            return

        try:
            await self.application.stop()
            await self.application.shutdown()
            self.is_running = False
            logger.info("Telegram bot stopped successfully")
        except Exception as e:
            logger.error(f"Error stopping Telegram bot: {e}")

    async def _start_command(self, update: Update, context):
        """Handle /start command."""
        user_id = str(update.effective_user.id)

        # Check if user is allowed
        if self.allowed_user_id and user_id != self.allowed_user_id:
            await update.message.reply_text(
                "⛔ You are not authorized to use this bot."
            )
            return

        await update.message.reply_text("👋 Hello! I am the NVIDIA NIM Proxy Bot.")

    async def _help_command(self, update: Update, context):
        """Handle /help command."""
        user_id = str(update.effective_user.id)

        # Check if user is allowed
        if self.allowed_user_id and user_id != self.allowed_user_id:
            return

        help_text = (
            "🤖 <b>NVIDIA NIM Proxy Bot</b>\n\n"
            "<b>Commands:</b>\n"
            "/start - Start the bot\n"
            "/help - Show this help\n"
            "/status - Show proxy status\n\n"
            "Send any message to interact with the AI!"
        )

        await update.message.reply_text(help_text, parse_mode=ParseMode.HTML)

    async def _status_command(self, update: Update, context):
        """Handle /status command."""
        user_id = str(update.effective_user.id)

        # Check if user is allowed
        if self.allowed_user_id and user_id != self.allowed_user_id:
            return

        status_text = (
            "✅ <b>NVIDIA NIM Proxy Status</b>\n\n"
            "• Online and ready\n"
            "• Model switching available\n"
            "• Web interface accessible"
        )

        await update.message.reply_text(status_text, parse_mode=ParseMode.HTML)

    async def _handle_message(self, update: Update, context):
        """Handle incoming text messages."""
        user_id = str(update.effective_user.id)

        # Check if user is allowed
        if self.allowed_user_id and user_id != self.allowed_user_id:
            await update.message.reply_text(
                "⛔ You are not authorized to use this bot."
            )
            return

        if self.message_handler:
            try:
                await self.message_handler(update.message.text, update)
            except Exception as e:
                logger.error(f"Error in message handler: {e}")
                await update.message.reply_text(
                    "❌ Sorry, an error occurred while processing your message."
                )
        else:
            await update.message.reply_text(
                "❌ Message handler not registered. Please contact administrator."
            )

    async def send_message(self, chat_id: str, text: str, parse_mode: str = ParseMode.MARKDOWN):
        """Send a message to a chat.

        Args:
            chat_id: Chat ID to send message to
            text: Message text
            parse_mode: Parse mode for formatting
        """
        if not self.application or not self.is_running:
            raise RuntimeError("Telegram bot is not running")

        try:
            await self.application.bot.send_message(
                chat_id=chat_id,
                text=text,
                parse_mode=parse_mode
            )
        except Exception as e:
            logger.error(f"Failed to send Telegram message: {e}")
            raise