"use strict"
Beautifier = require('./beautifier')

module.exports = class JSBeautify extends Beautifier
  name: "JS Beautify"

  options: {
    HTML: true
    XML: true
    Handlebars: true
    Mustache: true
    Marko: true
    JavaScript: true
    JSON: true
    CSS:
      indent_size: true
      indent_char: true
      selector_separator_newline: true
      newline_between_rules: true
      preserve_newlines: true
      wrap_line_length: true
  }

  beautify: (text, language, options) ->
    @verbose("JS Beautify language #{language}")
    return new @Promise((resolve, reject) =>
      try
        switch language
          when "JSON", "JavaScript"
            beautifyJS = require("js-beautify")
            text = beautifyJS(text, options)
            resolve text
          when "Handlebars", "Mustache"
            # jshint ignore: start
            options.indent_handlebars = true # Force jsbeautify to indent_handlebars
            # jshint ignore: end
            beautifyHTML = require("js-beautify").html
            text = beautifyHTML(text, options)
            resolve text
          when "HTML (Liquid)", "HTML", "XML", "Marko", "Web Form/Control (C#)", "Web Handler (C#)"
            beautifyHTML = require("js-beautify").html
            text = beautifyHTML(text, options)
            @debug("Beautified HTML: #{text}")
            resolve text
          when "CSS"
            beautifyCSS = require("js-beautify").css
            text = beautifyCSS(text, options)
            resolve text
      catch err
        @error("JS Beautify error: #{err}")
        reject(err)

    )
