#' Change the value of a text input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#'
#' @seealso \code{\link{textInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   sliderInput("controller", "Controller", 0, 20, 10),
#'   textInput("inText", "Input text"),
#'   textInput("inText2", "Input text 2")
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     # This will change the value of input$inText, based on x
#'     updateTextInput(session, "inText", value = paste("New text", x))
#'
#'     # Can also set the label, this time for input$inText2
#'     updateTextInput(session, "inText2",
#'       label = paste("New label", x),
#'       value = paste("New text", x))
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateTextInput <- function(session, inputId, label = NULL, value = NULL) {
  message <- dropNulls(list(label=label, value=value))
  session$sendInputMessage(inputId, message)
}

#' Change the value of a textarea input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#'
#' @seealso \code{\link{textAreaInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   sliderInput("controller", "Controller", 0, 20, 10),
#'   textAreaInput("inText", "Input textarea"),
#'   textAreaInput("inText2", "Input textarea 2")
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     # This will change the value of input$inText, based on x
#'     updateTextAreaInput(session, "inText", value = paste("New text", x))
#'
#'     # Can also set the label, this time for input$inText2
#'     updateTextAreaInput(session, "inText2",
#'       label = paste("New label", x),
#'       value = paste("New text", x))
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateTextAreaInput <- updateTextInput


#' Change the value of a checkbox input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#'
#' @seealso \code{\link{checkboxInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   sliderInput("controller", "Controller", 0, 1, 0, step = 1),
#'   checkboxInput("inCheckbox", "Input checkbox")
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     # TRUE if input$controller is odd, FALSE if even.
#'     x_even <- input$controller %% 2 == 1
#'
#'     updateCheckboxInput(session, "inCheckbox", value = x_even)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateCheckboxInput <- updateTextInput


#' Change the label or icon of an action button on the client
#'
#' @template update-input
#' @param icon The icon to set for the input object. To remove the
#' current icon, use \code{icon=character(0)}.
#'
#' @seealso \code{\link{actionButton}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   actionButton("update", "Update other buttons"),
#'   br(),
#'   actionButton("goButton", "Go"),
#'   br(),
#'   actionButton("goButton2", "Go 2", icon = icon("area-chart")),
#'   br(),
#'   actionButton("goButton3", "Go 3")
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     req(input$update)
#'
#'     # Updates goButton's label and icon
#'     updateActionButton(session, "goButton",
#'       label = "New label",
#'       icon = icon("calendar"))
#'
#'     # Leaves goButton2's label unchaged and
#'     # removes its icon
#'     updateActionButton(session, "goButton2",
#'       icon = character(0))
#'
#'     # Leaves goButton3's icon, if it exists,
#'     # unchaged and changes its label
#'     updateActionButton(session, "goButton3",
#'       label = "New label 3")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateActionButton <- function(session, inputId, label = NULL, icon = NULL) {
  if (!is.null(icon)) icon <- as.character(validateIcon(icon))
  message <- dropNulls(list(label=label, icon=icon))
  session$sendInputMessage(inputId, message)
}


#' Change the value of a date input on the client
#'
#' @template update-input
#' @param value The desired date value. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format. Supply \code{NA} to clear the date.
#' @param min The minimum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param max The maximum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#'
#' @seealso \code{\link{dateInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   sliderInput("controller", "Controller", 1, 30, 10),
#'   dateInput("inDate", "Input date")
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     updateDateInput(session, "inDate",
#'       label = paste("Date label", x),
#'       value = paste("2013-04-", x, sep=""),
#'       min   = paste("2013-04-", x-1, sep=""),
#'       max   = paste("2013-04-", x+1, sep="")
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateDateInput <- function(session, inputId, label = NULL, value = NULL,
                            min = NULL, max = NULL) {

  # Make sure values are NULL or Date objects. This is so we can ensure that
  # they will be formatted correctly. For example, the string "2016-08-9" is not
  # correctly formatted, but the conversion to Date and back to string will fix
  # it.
  formatDate <- function(x) {
    if (is.null(x))
      return(NULL)
    format(as.Date(x), "%Y-%m-%d")
  }
  value <- formatDate(value)
  min   <- formatDate(min)
  max   <- formatDate(max)

  message <- dropNulls(list(label=label, value=value, min=min, max=max))
  session$sendInputMessage(inputId, message)
}


#' Change the start and end values of a date range input on the client
#'
#' @template update-input
#' @param start The start date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format. Supplying \code{NA} clears the start date.
#' @param end The end date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format. Supplying \code{NA} clears the end date.
#' @param min The minimum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param max The maximum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#'
#' @seealso \code{\link{dateRangeInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   sliderInput("controller", "Controller", 1, 30, 10),
#'   dateRangeInput("inDateRange", "Input date range")
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     updateDateRangeInput(session, "inDateRange",
#'       label = paste("Date range label", x),
#'       start = paste("2013-01-", x, sep=""),
#'       end = paste("2013-12-", x, sep="")
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateDateRangeInput <- function(session, inputId, label = NULL,
                                 start = NULL, end = NULL, min = NULL,
                                 max = NULL) {
  # Make sure start and end are strings, not date objects. This is for
  # consistency across different locales.
  if (inherits(start, "Date"))  start <- format(start, '%Y-%m-%d')
  if (inherits(end, "Date"))    end <- format(end, '%Y-%m-%d')
  if (inherits(min, "Date"))    min <- format(min, '%Y-%m-%d')
  if (inherits(max, "Date"))    max <- format(max, '%Y-%m-%d')

  message <- dropNulls(list(
    label = label,
    value = list(start, end),
    min = min,
    max = max
  ))

  session$sendInputMessage(inputId, message)
}

#' Change the selected tab on the client
#'
#' @param session The \code{session} object passed to function given to
#'   \code{shinyServer}.
#' @param inputId The id of the \code{tabsetPanel}, \code{navlistPanel},
#' or \code{navbarPage} object.
#' @param selected The name of the tab to make active.
#'
#' @seealso \code{\link{tabsetPanel}}, \code{\link{navlistPanel}},
#' \code{\link{navbarPage}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(sidebarLayout(
#'   sidebarPanel(
#'     sliderInput("controller", "Controller", 1, 3, 1)
#'   ),
#'   mainPanel(
#'     tabsetPanel(id = "inTabset",
#'       tabPanel(title = "Panel 1", value = "panel1", "Panel 1 content"),
#'       tabPanel(title = "Panel 2", value = "panel2", "Panel 2 content"),
#'       tabPanel(title = "Panel 3", value = "panel3", "Panel 3 content")
#'     )
#'   )
#' ))
#'
#' server <- function(input, output, session) {
#'   observeEvent(input$controller, {
#'     updateTabsetPanel(session, "inTabset",
#'       selected = paste0("panel", input$controller)
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateTabsetPanel <- function(session, inputId, selected = NULL) {
  message <- dropNulls(list(value = selected))
  session$sendInputMessage(inputId, message)
}

#' @rdname updateTabsetPanel
#' @export
updateNavbarPage <- updateTabsetPanel

#' @rdname updateTabsetPanel
#' @export
updateNavlistPanel <- updateTabsetPanel

#' Change the value of a number input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#' @param min Minimum value.
#' @param max Maximum value.
#' @param step Step size.
#'
#' @seealso \code{\link{numericInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   sliderInput("controller", "Controller", 0, 20, 10),
#'   numericInput("inNumber", "Input number", 0),
#'   numericInput("inNumber2", "Input number 2", 0)
#' )
#'
#' server <- function(input, output, session) {
#'
#'   observeEvent(input$controller, {
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     updateNumericInput(session, "inNumber", value = x)
#'
#'     updateNumericInput(session, "inNumber2",
#'       label = paste("Number label ", x),
#'       value = x, min = x-10, max = x+10, step = 5)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateNumericInput <- function(session, inputId, label = NULL, value = NULL,
    min = NULL, max = NULL, step = NULL) {

  message <- dropNulls(list(
    label = label, value = formatNoSci(value),
    min = formatNoSci(min), max = formatNoSci(max), step = formatNoSci(step)
  ))
  session$sendInputMessage(inputId, message)
}

#' Change the value of a slider input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#' @param min Minimum value.
#' @param max Maximum value.
#' @param step Step size.
#'
#' @seealso \code{\link{sliderInput}}
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       sidebarLayout(
#'         sidebarPanel(
#'           p("The first slider controls the second"),
#'           sliderInput("control", "Controller:", min=0, max=20, value=10,
#'                        step=1),
#'           sliderInput("receive", "Receiver:", min=0, max=20, value=10,
#'                        step=1)
#'         ),
#'         mainPanel()
#'       )
#'     ),
#'     server = function(input, output, session) {
#'       observe({
#'         val <- input$control
#'         # Control the value, min, max, and step.
#'         # Step size is 2 when input value is even; 1 when value is odd.
#'         updateSliderInput(session, "receive", value = val,
#'           min = floor(val/2), max = val+4, step = (val+1)%%2 + 1)
#'       })
#'     }
#'   )
#' }
#' @export
updateSliderInput <- function(session, inputId, label = NULL, value = NULL,
  min = NULL, max = NULL, step = NULL)
{
  # Make sure that value, min, max all have the same type, because we need
  # special handling for dates and datetimes.
  vals <- dropNulls(list(value, min, max))

  type <- unique(lapply(vals, function(x) {
    if      (inherits(x, "Date"))   "date"
    else if (inherits(x, "POSIXt")) "datetime"
    else                            "number"
  }))
  if (length(type) > 1) {
    stop("Type mismatch for value, min, and max")
  }

  if ((length(type) == 1) && (type == "date" || type == "datetime")) {
    to_ms <- function(x) 1000 * as.numeric(as.POSIXct(x))
    if (!is.null(min))   min   <- to_ms(min)
    if (!is.null(max))   max   <- to_ms(max)
    if (!is.null(value)) value <- to_ms(value)
  }

  message <- dropNulls(list(
    label = label,
    value = formatNoSci(value),
    min = formatNoSci(min),
    max = formatNoSci(max),
    step = formatNoSci(step)
  ))
  session$sendInputMessage(inputId, message)
}


updateInputOptions <- function(session, inputId, label = NULL, choices = NULL,
                               selected = NULL, inline = FALSE,
                               type = 'checkbox') {
  if (!is.null(choices))
    choices <- choicesWithNames(choices)
  if (!is.null(selected))
    selected <- validateSelected(selected, choices, session$ns(inputId))

  options <- if (!is.null(choices)) {
    format(tagList(
      generateOptions(session$ns(inputId), choices, selected, inline, type = type)
    ))
  }

  message <- dropNulls(list(label = label, options = options, value = selected))

  session$sendInputMessage(inputId, message)
}

#' Change the value of a checkbox group input on the client
#'
#' @template update-input
#' @inheritParams checkboxGroupInput
#'
#' @seealso \code{\link{checkboxGroupInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   p("The first checkbox group controls the second"),
#'   checkboxGroupInput("inCheckboxGroup", "Input checkbox",
#'     c("Item A", "Item B", "Item C")),
#'   checkboxGroupInput("inCheckboxGroup2", "Input checkbox 2",
#'     c("Item A", "Item B", "Item C"))
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     x <- input$inCheckboxGroup
#'
#'     # Can use character(0) to remove all choices
#'     if (is.null(x))
#'       x <- character(0)
#'
#'     # Can also set the label and select items
#'     updateCheckboxGroupInput(session, "inCheckboxGroup2",
#'       label = paste("Checkboxgroup label", length(x)),
#'       choices = x,
#'       selected = x
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateCheckboxGroupInput <- function(session, inputId, label = NULL,
                                     choices = NULL, selected = NULL,
                                     inline = FALSE) {
  updateInputOptions(session, inputId, label, choices, selected, inline)
}


#' Change the value of a radio input on the client
#'
#' @template update-input
#' @inheritParams radioButtons
#'
#' @seealso \code{\link{radioButtons}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   p("The first radio button group controls the second"),
#'   radioButtons("inRadioButtons", "Input radio buttons",
#'     c("Item A", "Item B", "Item C")),
#'   radioButtons("inRadioButtons2", "Input radio buttons 2",
#'     c("Item A", "Item B", "Item C"))
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     x <- input$inRadioButtons
#'
#'     # Can also set the label and select items
#'     updateRadioButtons(session, "inRadioButtons2",
#'       label = paste("radioButtons label", x),
#'       choices = x,
#'       selected = x
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateRadioButtons <- function(session, inputId, label = NULL, choices = NULL,
                               selected = NULL, inline = FALSE) {
  if (!is.null(choices)) choices <- as.character(choices)
  if (!is.null(selected)) selected <- as.character(selected)

  # you must select at least one radio button
  if (is.null(selected) && !is.null(choices)) selected <- choices[[1]]
  updateInputOptions(session, inputId, label, choices, selected, inline, type = 'radio')
}


#' Change the value of a select input on the client
#'
#' @template update-input
#' @inheritParams selectInput
#'
#' @seealso \code{\link{selectInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   p("The checkbox group controls the select input"),
#'   checkboxGroupInput("inCheckboxGroup", "Input checkbox",
#'     c("Item A", "Item B", "Item C")),
#'   selectInput("inSelect", "Select input",
#'     c("Item A", "Item B", "Item C"))
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     x <- input$inCheckboxGroup
#'
#'     # Can use character(0) to remove all choices
#'     if (is.null(x))
#'       x <- character(0)
#'
#'     # Can also set the label and select items
#'     updateSelectInput(session, "inSelect",
#'       label = paste("Select input label", length(x)),
#'       choices = x,
#'       selected = tail(x, 1)
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateSelectInput <- function(session, inputId, label = NULL, choices = NULL,
                              selected = NULL) {
  choices <- if (!is.null(choices)) choicesWithNames(choices)
  if (!is.null(selected))
    selected <- validateSelected(selected, choices, inputId)
  options <- if (!is.null(choices)) selectOptions(choices, selected)
  message <- dropNulls(list(label = label, options = options, value = selected))
  session$sendInputMessage(inputId, message)
}

#' @rdname updateSelectInput
#' @inheritParams selectizeInput
#' @param server whether to store \code{choices} on the server side, and load
#'   the select options dynamically on searching, instead of writing all
#'   \code{choices} into the page at once (i.e., only use the client-side
#'   version of \pkg{selectize.js})
#' @export
updateSelectizeInput <- function(session, inputId, label = NULL, choices = NULL,
                                 selected = NULL, options = list(),
                                 server = FALSE) {
  if (length(options)) {
    res <- checkAsIs(options)
    cfg <- tags$script(
      type = 'application/json',
      `data-for` = inputId,
      `data-eval` = if (length(res$eval)) HTML(toJSON(res$eval)),
      HTML(toJSON(res$options))
    )
    session$sendInputMessage(inputId, list(config = as.character(cfg)))
  }
  if (!server) {
    return(updateSelectInput(session, inputId, label, choices, selected))
  }
  value <- unname(selected)
  attr(choices, 'selected_value') <- value
  message <- dropNulls(list(
    label = label,
    value = value,
    url = session$registerDataObj(inputId, choices, selectizeJSON)
  ))
  session$sendInputMessage(inputId, message)
}

selectizeJSON <- function(data, req) {
  query <- parseQueryString(req$QUERY_STRING)
  # extract the query variables, conjunction (and/or), search string, maximum options
  var <- c(jsonlite::fromJSON(query$field))
  cjn <- if (query$conju == 'and') all else any
  # all keywords in lower-case, for case-insensitive matching
  key <- unique(strsplit(tolower(query$query), '\\s+')[[1]])
  if (identical(key, '')) key <- character(0)
  mop <- as.numeric(query$maxop)
  vfd <- query$value  # the value field name
  sel <- attr(data, 'selected_value', exact = TRUE)

  # convert a single vector to a data frame so it returns {label: , value: }
  # later in JSON; other objects return arbitrary JSON {x: , y: , foo: , ...}
  data <- if (is.atomic(data)) {
    data.frame(label = names(choicesWithNames(data)), value = data,
               stringsAsFactors = FALSE)
  } else as.data.frame(data, stringsAsFactors = FALSE)

  # start searching for keywords in all specified columns
  idx <- logical(nrow(data))
  if (length(key)) for (v in var) {
    matches <- do.call(
      cbind,
      lapply(key, function(k) {
        grepl(k, tolower(as.character(data[[v]])), fixed = TRUE)
      })
    )
    # merge column matches using OR, and match multiple keywords in one column
    # using the conjunction setting (AND or OR)
    idx <- idx | apply(matches, 1, cjn)
  }
  # only return the first n rows (n = maximum options in configuration)
  idx <- utils::head(if (length(key)) which(idx) else seq_along(idx), mop)
  # make sure the selected value is in the data
  if (length(sel)) {
    i <- stats::na.omit(match(sel, data[, vfd]))
    if (length(i)) idx <- sort(utils::head(unique(c(i, idx)), mop))
  }
  data <- data[idx, ]

  res <- toJSON(columnToRowData(data))
  httpResponse(200, 'application/json', enc2utf8(res))
}
