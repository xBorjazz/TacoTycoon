@tool
extends EditorPlugin

# A class member to hold the editor export plugin during its lifecycle.
var export_plugin : AndroidExportPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	# Plugin's name.
	var _plugin_name = "PGSGP"

	# Specifies which platform is supported by the plugin.
	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	# Return the paths of the plugin's AAR binaries relative to the 'addons' directory.
	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray(["PGSGP/GodotPlayGamesServices.release.aar"])
		else:
			return PackedStringArray(["PGSGP/GodotPlayGamesServices.release.aar"])
	
	func _get_android_dependencies(platform, debug):
		# TODO: Add remote dependices here.
		if debug:
			return PackedStringArray(["com.google.android.gms:play-services-games:23.1.0","com.google.android.gms:play-services-auth:20.6.0", "com.google.code.gson:gson:2.8.6"])
		else:
			return PackedStringArray(["com.google.android.gms:play-services-games:23.1.0","com.google.android.gms:play-services-auth:20.6.0", "com.google.code.gson:gson:2.8.6"])
	# Return the plugin's name.
	func _get_name():
		return _plugin_name
