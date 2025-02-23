package io.cgisca.godot.gpgs.savedgames

interface SavedGamesListener {
    fun onSavedGameSuccess()
    fun onSavedGameFailed(saveError: String)
    fun onSavedGameLoadFailed(loadError: String)
    fun onSavedGameLoadSuccess(data: String)
    fun onSavedGameCreateSnapshot(currentSaveName: String)
}