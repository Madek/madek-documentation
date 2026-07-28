# Madek technical documentation

This site is the **technical system and developer documentation** for Madek
([madek.readthedocs.org](https://madek.readthedocs.org/)).

It covers architecture, concepts, how to develop and integrate with Madek,
and project process. It is **not** end-user help.

## Who this is for

- **Primary:** developers (onboarding and day-to-day work) who need technical
  system understanding
- **Secondary:** API integrators; admins working with system/config (`/admin`)

End-user how-tos, pure `/admin` operation, ZHdK instance specifics, and
ticket-style support live elsewhere (see below).

## Where else to look

| Need | Go to |
|------|--------|
| End-user **help** (how-tos, UI, FAQ, glossary) | [User documentation (doku.madek.ch)](https://doku.madek.ch/) |
| **Support** / ticket-oriented notes | [Medienarchiv Wiki](https://wiki.zhdk.ch/medienarchiv/doku.php) |
| API endpoint / schema **reference** (API) | [API Browser](https://zhdk.medienarchiv.ch/api/browser) *(ZHdK instance example)* |
| API-v2 endpoint / schema **reference** | [Swagger UI](https://zhdk.medienarchiv.ch/api-v2/api-docs/index.html#/) *(ZHdK instance example)* |
| Featurescape overview (PDF) | [Featurescape](http://medienarchiv.zhdk.ch/entries/featurescape) *(maintained by S. Schumacher)* |

## Navigate this site

| Section | Use it when you want… |
|---------|------------------------|
| [Madek at a glance](start/madek-at-a-glance.md) | A short big-picture of surfaces, components, and technical lifecycles |
| [Concepts & system](concepts/media-types.md) | Why/how the system behaves (model and behaviour) |
| [Developing Madek](developing/setup.md) | How to develop (setup, conventions, guides) |
| [API](api/index.md) | Orientation for integrating — not endpoint reference |
| [Architecture](architecture/index.md) | Where things live in code, DB, and services |
| [Project](project/branches.md) | Branches, review, contribution, thin ops notes |

**Suggested paths**

1. **Understand** → [Madek at a glance](start/madek-at-a-glance.md) → Concepts → Architecture  
2. **Develop** → Developing → Architecture → Project  
3. **API** → [API hub](api/index.md) → Swagger / API Browser  
4. **End-user help** → User documentation; **Support** → Wiki  
