@tool # Needed so it runs in editor.
extends EditorScenePostImport

# Import Script for floors, gives them collision meshes and sets them to layer 3
func _post_import(scene):
	iterate(scene)
	return scene

# Recursive function that is called on every node
# (for demonstration purposes; EditorScenePostImport only requires a `_post_import(scene)` function).
func iterate(node):
	if node != null:
		if node is MeshInstance3D:
			node.create_trimesh_collision()
			node.set_layer_mask_value(1, false)
			node.set_layer_mask_value(3, true)
		for child in node.get_children():
			iterate(child)
