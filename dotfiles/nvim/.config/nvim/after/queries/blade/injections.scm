;; extends
((text) @injection.content
    (#not-has-ancestor? @injection.content "envoy")
    (#set! injection.language "php"))

((php_only) @injection.content
    (#set! injection.language "php"))
