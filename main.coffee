rxt.importTags()
bind = rx.bind

# const
DEBUG = false
PARTS = 3
TWITTER = "killercup"

parts_ = [0..PARTS-1]

cats = window.categories

name_parts = rx.array _(cats).chain().keys().sample(PARTS).value()

final_name = bind ->
  return console.error name_parts, 'is not cool' unless name_parts?.all?()?.length

  name_parts.all()
  .map (cat) ->
    vals = cats[cat]?.values
    return unless vals?.length
    _.sample(vals, 1)[0]
  .join(" ").split(" ")
  .map(_.str.capitalize)
  .join(" ")

optionsFor = (categories, selected) ->
  _(categories).chain()
  .pairs()
  .sortBy((a) -> a[0])
  .map ([key, cat]) ->
    option {
      value: key
      selected: (key is selected)
    }, cat.name
  .value()

sourceInfo = (categories, selected) ->
  if '' is selected
    return "(Will be ignored.)"
  sec = categories?[selected]
  return console.error selected, "is not a section of", categories unless sec?.source?
  a {href: sec.source}, "Source"

selects = (name_parts, final_name) ->
  section {class: 'panel panel-default'}, [
    form {
      class: 'panel-body form-inline text-center'
      submit: (ev) ->
        ev.preventDefault()
        final_name.refresh()
    },
      parts_.map (i) ->
        div {class: 'form-group'}, [
          select {
            class: 'form-control input-lg'
            change: ->
              name_parts.splice i, 1, @val()
          }, [
            option {value: ''}, '– Nope –'
          ].concat optionsFor categories, name_parts.at(i)

          div {class: 'help-block'}, bind ->
            [sourceInfo categories, name_parts.at(i)]
        ]
      .concat [
        div {class: 'form-group'}, [
          button {
            class: 'btn btn-lg btn-primary'
            type: 'submit'
          }, [
            i {class: "icon-random"}, ' '
            "Generate!"
          ]

          div {class: 'help-block'}, "Click it again!"
        ]
      ]
    ]

tweetButton = (final_name) ->
  a {
    class: "btn btn-primary"
    target: "_blank"
    href: bind ->
      "https://twitter.com/share?related=#{TWITTER}&via=#{TWITTER}&text=#{encodeURIComponent 'Codename: '+final_name.get()}&url=#{window.location.origin}"
  }, [
    i {class: "icon-twitter"}, ' '
    "Tweet"
  ]

adnButton = (final_name) ->
  a {
    class: "btn btn-default"
    target: "_blank"
    href: bind ->
      "https://alpha.app.net/intent/post/?text=#{encodeURIComponent 'Codename: '+final_name.get()}&url=#{window.location.origin}"
  }, [
    i {class: "icon-adn"}, ' '
    "ADN"
  ]

jQuery ($) ->
  if DEBUG
    window.n = name_parts
    window.f = final_name

  $('body').addClass 'js'

  $('#selects')
    .append selects(name_parts, final_name)

  $('#final_name')
    .append(span(final_name))
  $('#share')
    .append(adnButton(final_name))
    .append(" ")
    .append(tweetButton(final_name))
