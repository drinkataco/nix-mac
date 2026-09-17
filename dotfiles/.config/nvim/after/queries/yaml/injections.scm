;; Inject embedded languages into YAML block scalars based on their key name.
;; The `#offset!` skips the `|`/`>` header line so the child parser only sees
;; the actual block content.

;; branding_custom_css: |     →  CSS
;;   .foo { ... }
((block_mapping_pair
  key: (flow_node) @_key
  value: (block_node (block_scalar) @injection.content))
  (#match? @_key "_css$")
  (#offset! @injection.content 1 0 0 0)
  (#set! injection.language "css"))

;; branding.yaml: |            →  YAML (nested document, e.g. ConfigMap.data)
;; auth-flow.yaml: |
((block_mapping_pair
  key: (flow_node) @_key
  value: (block_node (block_scalar) @injection.content))
  (#match? @_key "\\.yaml$")
  (#offset! @injection.content 1 0 0 0)
  (#set! injection.language "yaml"))
