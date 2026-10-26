class_name NodeUtils 
extends RefCounted

static func safe_remove_child(parent: Node, child: Node) -> bool:
	if is_instance_valid(child) and child.get_parent() == parent:
		parent.remove_child(child)
		return true
	return false
