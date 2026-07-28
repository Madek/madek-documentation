# Permissions

Madek authorizes access with per-resource ACL rows plus optional public flags
on the resource itself. End-user sharing UI belongs in
[User documentation](https://doku.madek.ch/). Data-model detail:
[Entities](../architecture/entities.md).

## Actions

Permission columns live on `*_user_permission`, `*_group_permission`, and
`*_api_client_permission` tables (`datalayer` `Permissions::*`).

| Resource | Actions (`PERMISSION_TYPES`) |
|----------|------------------------------|
| **MediaEntry** | `get_metadata_and_previews`, `get_full_size`, `edit_metadata`, `edit_permissions` |
| **Collection** | `get_metadata_and_previews`, `edit_metadata_and_relations`, `edit_permissions` |
| **Vocabulary** | `view`, `use` |

Public discoverability can also be set on the resource row (e.g.
`media_entries.get_metadata_and_previews`, `get_full_size`).

## Subjects

Who receives a permission row:

| Subject | Notes |
|---------|--------|
| **User** | Direct grant; may use **Delegation** (`user_id` XOR `delegation_id` on user-permission rows) |
| **Group** | Including institutional / authentication groups |
| **ApiClient** | Machine clients; typically view/download style rights, not full manage |

## Entrusted resources

A resource is **entrusted** to a subject when that subject has the view-level
permission via user, group, or api_client rows (`Entrust` concern:
`entrusted_to_user` / `entrusted_to_api_client`, etc.). Dashboards and filters
expose “entrusted to me” using this notion. See also
[Feature groups — entrusted](feature-groups.md#entrusted).

## Webapp enforcement

Rails policies under `webapp/app/policies/` (and shared media-resource scopes:
Viewable / Editable / Manageable) map UI actions onto the permission helpers.
Creator rules for **unpublished** entries are special-cased until publish
(see [Madek at a glance](../start/madek-at-a-glance.md#upload--preview--publish)).

**Uberadmin mode** bypasses normal ACL checks in the webapp for users in the
`admins` table — see [Uberadmin](uberadmin.md). That bypass is separate from
granting permission rows.
