Image = "{{image}}"
<* for name, value in colors *>
{{name | pascal_case }} = "0xff{{value.default.hex_stripped}}"
<* endfor *>
