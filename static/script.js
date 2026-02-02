// API base URL
const API_BASE = '';

// DOM elements
const currentModelNameEl = document.getElementById('current-model-name');
const currentModelOwnerEl = document.getElementById('current-model-owner');
const currentModelSettingsEl = document.getElementById('current-model-settings');
const modelsListEl = document.getElementById('models-list');
const modelSearchEl = document.getElementById('model-search');
const notificationEl = document.getElementById('notification');
const notificationMessageEl = document.getElementById('notification-message');

// State
let allModels = [];
let currentModel = null;

// Initialize the app
document.addEventListener('DOMContentLoaded', async () => {
    await loadCurrentModel();
    await loadModels();

    // Set up search functionality
    modelSearchEl.addEventListener('input', filterModels);
});

// Load current model information
async function loadCurrentModel() {
    try {
        const response = await fetch(`${API_BASE}/v1/models/current`);
        if (!response.ok) throw new Error('Failed to load current model');

        currentModel = await response.json();
        updateCurrentModelDisplay();
    } catch (error) {
        showNotification(`Error loading current model: ${error.message}`, 'error');
    }
}

// Load all available models
async function loadModels() {
    try {
        const response = await fetch(`${API_BASE}/v1/models`);
        if (!response.ok) throw new Error('Failed to load models');

        const data = await response.json();
        allModels = data.data;
        renderModels(allModels);
    } catch (error) {
        showNotification(`Error loading models: ${error.message}`, 'error');
        modelsListEl.innerHTML = `<p>Error loading models: ${error.message}</p>`;
    }
}

// Update current model display
function updateCurrentModelDisplay() {
    if (!currentModel) return;

    currentModelNameEl.textContent = currentModel.id;
    currentModelOwnerEl.textContent = currentModel.owned_by ? `Owned by: ${currentModel.owned_by}` : '';

    if (currentModel.settings) {
        const settingsHtml = Object.entries(currentModel.settings)
            .map(([key, value]) => `<li>${key}: ${value}</li>`)
            .join('');
        currentModelSettingsEl.innerHTML = settingsHtml;
    } else {
        currentModelSettingsEl.innerHTML = '<li>No settings available</li>';
    }
}

// Render models list
function renderModels(models) {
    if (models.length === 0) {
        modelsListEl.innerHTML = '<p>No models found</p>';
        return;
    }

    const modelsHtml = models.map(model => {
        const isSelected = currentModel && model.id === currentModel.id;
        const selectedClass = isSelected ? 'selected' : '';
        const ownerInfo = model.owned_by ? `Owned by: ${model.owned_by}` : '';

        return `
            <div class="model-item ${selectedClass}" data-model-id="${model.id}">
                <h3>${model.id}</h3>
                <p class="model-owner">${ownerInfo}</p>
                <button class="switch-button" onclick="switchModel('${model.id}')">
                    ${isSelected ? 'Current Model' : 'Switch to Model'}
                </button>
            </div>
        `;
    }).join('');

    modelsListEl.innerHTML = modelsHtml;
}

// Filter models based on search input
function filterModels() {
    const searchTerm = modelSearchEl.value.toLowerCase();

    if (!searchTerm) {
        renderModels(allModels);
        return;
    }

    const filteredModels = allModels.filter(model =>
        model.id.toLowerCase().includes(searchTerm) ||
        (model.owned_by && model.owned_by.toLowerCase().includes(searchTerm))
    );

    renderModels(filteredModels);
}

// Switch to a different model
async function switchModel(modelId) {
    try {
        // Disable all buttons during switching
        document.querySelectorAll('.switch-button').forEach(btn => {
            btn.disabled = true;
            if (btn.parentElement.dataset.modelId === modelId) {
                btn.textContent = 'Switching...';
            }
        });

        const response = await fetch(`${API_BASE}/v1/models/switch`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ model: modelId }),
        });

        if (!response.ok) {
            const errorData = await response.json().catch(() => ({}));
            throw new Error(errorData.detail || 'Failed to switch model');
        }

        const result = await response.json();
        showNotification(result.message, 'success');

        // Update current model
        currentModel = result;
        updateCurrentModelDisplay();

        // Re-render models to update selection status
        filterModels();
    } catch (error) {
        showNotification(`Error switching model: ${error.message}`, 'error');
    } finally {
        // Re-enable all buttons
        document.querySelectorAll('.switch-button').forEach(btn => {
            btn.disabled = false;
            if (btn.parentElement.dataset.modelId === currentModel.id) {
                btn.textContent = 'Current Model';
            } else {
                btn.textContent = 'Switch to Model';
            }
        });
    }
}

// Show notification
function showNotification(message, type) {
    notificationMessageEl.textContent = message;
    notificationEl.className = `notification ${type} show`;

    setTimeout(() => {
        notificationEl.classList.remove('show');
    }, 3000);
}

// Add event listener for Enter key in search
modelSearchEl.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        filterModels();
    }
});