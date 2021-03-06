plot.cca1<- function (x, choices = c(1, 2), display = c("sp", "wa", "cn"), 
    scaling = "species", type, xlim, ylim, const, correlation = FALSE, 
    hill = FALSE, cex.sites = 1, cex.spec=1, col.sites = "brown", col.spec = "forestgreen",
	pch.sites = 20, pch.spec = 17,...) 
{
    TYPES <- c("text", "points", "none")
    g <- scores(x, choices, display, scaling, const, correlation = correlation, 
        hill = hill)
    if (length(g) == 0 || all(is.na(g))) 
        stop("nothing to plot: requested scores do not exist")
    if (!is.list(g)) 
        g <- list(default = g)
    for (i in seq_along(g)) {
        if (length(dim(g[[i]])) > 1) 
            rownames(g[[i]]) <- rownames(g[[i]], do.NULL = FALSE, 
                prefix = substr(names(g)[i], 1, 3))
    }
    if (!is.null(g$centroids)) {
        if (is.null(g$biplot)) 
            g$biplot <- scores(x, choices, "bp", scaling)
        if (!is.na(g$centroids)[1]) {
            bipnam <- rownames(g$biplot)
            cntnam <- rownames(g$centroids)
            g$biplot <- g$biplot[!(bipnam %in% cntnam), , drop = FALSE]
            if (nrow(g$biplot) == 0) 
                g$biplot <- NULL
        }
    }
    if (missing(type)) {
        nitlimit <- 80
        nit <- max(nrow(g$spe), nrow(g$sit), nrow(g$con), nrow(g$def))
        if (nit > nitlimit) 
            type <- "points"
        else type <- "text"
    }
    else type <- match.arg(type, TYPES)
    if (length(choices) == 1) {
        if (length(g) == 1) 
            pl <- linestack(g[[1]], ...)
        else {
            hasSpec <- names(g)[1] == "species"
            ylim <- range(c(g[[1]], g[[2]]), na.rm = TRUE)
            pl <- linestack(g[[1]], ylim = ylim, side = ifelse(hasSpec, 
                "left", "right"), ...)
            linestack(g[[2]], ylim = ylim, side = ifelse(hasSpec, 
                "right", "left"), add = TRUE, ...)
        }
        return(invisible(pl))
    }
    if (missing(xlim)) {
        xlim <- range(g$species[, 1], g$sites[, 1], g$constraints[, 
            1], g$biplot[, 1], if (length(g$centroids) > 0 && 
            is.na(g$centroids)) NA else g$centroids[, 1], g$default[, 
            1], na.rm = TRUE)
    }
    if (!any(is.finite(xlim))) 
        stop("no finite scores to plot")
    if (missing(ylim)) {
        ylim <- range(g$species[, 2], g$sites[, 2], g$constraints[, 
            2], g$biplot[, 2], if (length(g$centroids) > 0 && 
            is.na(g$centroids)) NA else g$centroids[, 2], g$default[, 
            2], na.rm = TRUE)
    }
    plot(g[[1]], xlim = xlim, ylim = ylim, type = "n", asp = 1, 
        ...)
    abline(h = 0, lty = 3)
    abline(v = 0, lty = 3)
    if (!is.null(g$species)) {
        if (type == "text") 
            text(g$species, rownames(g$species), col = "red", 
                cex = 0.7)
        else if (type == "points") 
            points(g$species, pch = pch.spec, col = col.spec, cex = cex.spec)
    }
    if (!is.null(g$sites)) {
        if (type == "text") 
            text(g$sites, rownames(g$sites), cex = 0.7)
        else if (type == "points") 
            points(g$sites, pch = pch.sites, cex = cex.sites, col = col.sites)
    }
    if (!is.null(g$constraints)) {
        if (type == "text") 
            text(g$constraints, rownames(g$constraints), cex = 0.7, 
                col = "darkgreen")
        else if (type == "points") 
            points(g$constraints, pch = 2, cex = 0.7, col = "darkgreen")
    }
    if (!is.null(g$biplot) && nrow(g$biplot) > 0 && type != "none") {
        if (length(display) > 1) {
            mul <- ordiArrowMul(g$biplot)
        }
        else mul <- 1
        attr(g$biplot, "arrow.mul") <- mul
        arrows(0, 0, mul * g$biplot[, 1], mul * g$biplot[, 2], 
            length = 0.05, col = "blue")
        biplabs <- ordiArrowTextXY(mul * g$biplot, rownames(g$biplot))
        text(biplabs, rownames(g$biplot), col = "blue")
        axis(3, at = c(-mul, 0, mul), labels = rep("", 3), col = "blue")
        axis(4, at = c(-mul, 0, mul), labels = c(-1, 0, 1), col = "blue")
    }
    if (!is.null(g$centroids) && !is.na(g$centroids) && type != 
        "none") {
        if (type == "text") 
            text(g$centroids, rownames(g$centroids), col = "blue")
        else if (type == "points") 
            points(g$centroids, pch = "x", col = "blue")
    }
    if (!is.null(g$default) && type != "none") {
        if (type == "text") 
            text(g$default, rownames(g$default), cex = 0.7)
        else if (type == "points") 
            points(g$default, pch = 1, cex = 0.7)
    }
    class(g) <- "ordiplot"
    invisible(g)
}
