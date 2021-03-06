##' create meme
##'
##'
##' @title meme
##' @param img path or url
##' @param upper upper text
##' @param lower lower text
##' @param size size of text
##' @param color color of text
##' @param font font family of text
##' @param vjust vertical adjustment of captions
##' @param bgcolor background color of shadow text
##' @param r ratio of shadow text
##' @param density resolution to render pdf or svg
##' @return grob object
##' @importFrom magick image_read
##' @importFrom magick image_info
##' @importFrom grid textGrob
##' @importFrom grid rasterGrob
##' @importFrom grid gpar
##' @importFrom grid viewport
##' @importFrom grid grid.draw
##' @importFrom grid gList
##' @importFrom grDevices dev.new
##' @export
##' @examples
##' f <- system.file("angry8.jpg", package="meme")
##' meme(f, "code", "all the things!", font = "Helvetica")
##' @author guangchuang yu
meme <- function(img, upper="", lower="", size="auto", color="white", font="Impact",
                 vjust = .05, bgcolor="black", r = 0.2, density = NULL) {
    x <- image_read(img, density=density)
    info <- image_info(x)

    imageGrob <- rasterGrob(x)

    p <- structure(
        list(img = img, imageGrob = imageGrob,
             width = info$width, height = info$height,
             upper=upper, lower=lower,
             size = size, color = color,
             font = font, vjust = vjust,
             bgcolor = bgcolor, r = r),
        class = c("meme", "recordedplot"))
    p
}

##' save meme plot
##'
##'
##' @title meme_save
##' @param x meme output
##' @param file output file
##' @param width width of graph
##' @param height height of graph
##' @param ... additional arguments for ggsave
##' @return NULL
##' @importFrom methods is
##' @importFrom graphics plot
##' @importFrom ggplot2 ggsave
##' @export
##' @examples
##' f <- system.file("angry8.jpg", package="meme")
##' x <- meme(f, "code", "all the things!")
##' outfile <- tempfile(fileext = ".png")
##' meme_save(x, outfile)
##' @author guangchuang yu
meme_save <- function(x, file, width = NULL, height = NULL, ...) {
    if (!is(x, "meme")) {
        stop("x should be an instance of 'meme'")
    }

    if (is.null(width) && is.null(height)) {
        width <- px2in(x$width)
        height <- px2in(x$height)
    } else if (is.null(width)) {
        width <- height / asp(x)
    } else {
        height <- width * asp(x)
    }

    ggsave(filename = file, plot = x,
           width = width,
           height = height,
           ...)
}


##' @method + meme
##' @importFrom utils modifyList
##' @export
"+.meme" <- function(e1, e2) {
    if (is(e2, "uneval"))
        e2 <- as.character(e2)
    params <- as.list(e2)
    names(params)[names(params) == "colour"] <- "color"
    params <- params[!sapply(params, is.null)]
    params <- params[names(params) %in% names(e1)]
    modifyList(e1, params)
}


##' plot the image for meme (captions to be added)
##'
##'
##' @title mmplot
##' @param x image file
##' @return meme object
##' @export
##' @author guangchuang yu
mmplot <- function(x) {
    meme(x)
}

##' add caption layer for meme
##'
##'
##' @title mm_caption
##' @param upper upper caption
##' @param lower lower caption
##' @param ... additional parameters to set caption
##' @return meme object
##' @export
##' @author guangchuang yu
mm_caption <- function(upper=NULL, lower=NULL, ...) {
    list(upper = upper, lower = lower, ...)
}


