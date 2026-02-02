"""Model presets management for NVIDIA NIM models."""

import json
import os
from typing import List, Dict, Optional
from pathlib import Path
from config.settings import get_settings

# Path to the current model configuration file
CURRENT_MODEL_FILE = Path(__file__).parent / "current_model.json"


class ModelPresetsManager:
    """Manages NVIDIA NIM model presets and current model selection."""

    def __init__(self):
        """Initialize the NVIDIA NIM model presets manager."""
        self.models_file = Path(__file__).parent.parent / "nvidia_nim_models.json"
        self._load_models()

    def _load_models(self):
        """Load NVIDIA NIM models from the JSON file."""
        try:
            with open(self.models_file, 'r') as f:
                self.model_data = json.load(f)
        except FileNotFoundError:
            # Fallback to empty model list if file not found
            self.model_data = {"object": "list", "data": []}

    def get_available_models(self) -> List[Dict]:
        """Get all available NVIDIA NIM models.

        Returns:
            List of NVIDIA NIM model dictionaries with id, object, created, and owned_by fields.
        """
        return self.model_data.get("data", [])

    def get_current_model_id(self) -> str:
        """Get the currently selected NVIDIA NIM model ID.

        Returns:
            The ID of the currently selected NVIDIA NIM model.
        """
        # Try to load from persistent storage first
        if CURRENT_MODEL_FILE.exists():
            try:
                with open(CURRENT_MODEL_FILE, 'r') as f:
                    data = json.load(f)
                    if "model" in data:
                        return data["model"]
            except (json.JSONDecodeError, KeyError):
                pass

        # Fallback to the model from settings
        settings = get_settings()
        return settings.model

    def get_current_model(self) -> Dict:
        """Get the currently selected NVIDIA NIM model with full information.

        Returns:
            Dictionary with NVIDIA NIM model information and settings.
        """
        current_model_id = self.get_current_model_id()
        settings = get_settings()

        # Find the model in our available models
        for model in self.get_available_models():
            if model["id"] == current_model_id:
                return {
                    "id": model["id"],
                    "object": model["object"],
                    "created": model["created"],
                    "owned_by": model["owned_by"],
                    "settings": {
                        "temperature": settings.nvidia_nim_temperature,
                        "top_p": settings.nvidia_nim_top_p,
                        "max_tokens": settings.nvidia_nim_max_tokens,
                    }
                }

        # If not found, return the settings model with default metadata
        return {
            "id": current_model_id,
            "object": "model",
            "settings": {
                "temperature": settings.nvidia_nim_temperature,
                "top_p": settings.nvidia_nim_top_p,
                "max_tokens": settings.nvidia_nim_max_tokens,
            }
        }

    def switch_model(self, model_id: str) -> Dict:
        """Switch to a different NVIDIA NIM model.

        Args:
            model_id: The ID of the NVIDIA NIM model to switch to

        Returns:
            Dictionary with the new NVIDIA NIM model information and switch status.

        Raises:
            ValueError: If the model_id is not found in available NVIDIA NIM models
        """
        # Verify the model exists
        model_found = False
        target_model = None
        for model in self.get_available_models():
            if model["id"] == model_id:
                model_found = True
                target_model = model
                break

        if not model_found:
            raise ValueError(f"NVIDIA NIM Model '{model_id}' not found in available models")

        # Get current model before switching
        previous_model = self.get_current_model_id()

        # Save to persistent storage
        with open(CURRENT_MODEL_FILE, 'w') as f:
            json.dump({"model": model_id}, f)

        return {
            "id": target_model["id"],
            "object": target_model["object"],
            "created": target_model.get("created", 0),
            "owned_by": target_model.get("owned_by", "nvidia"),
            "message": "NVIDIA NIM Model switched successfully",
            "previous_model": previous_model,
            "settings": {
                "temperature": get_settings().nvidia_nim_temperature,
                "top_p": get_settings().nvidia_nim_top_p,
                "max_tokens": get_settings().nvidia_nim_max_tokens,
            }
        }

    def get_model_by_id(self, model_id: str) -> Optional[Dict]:
        """Get a specific NVIDIA NIM model by its ID.

        Args:
            model_id: The ID of the NVIDIA NIM model to retrieve

        Returns:
            NVIDIA NIM model dictionary if found, None otherwise
        """
        for model in self.get_available_models():
            if model["id"] == model_id:
                return model
        return None


# Global instance
model_presets_manager = ModelPresetsManager()