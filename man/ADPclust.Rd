% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ADPclust.R
\name{adpclust}
\alias{adpclust}
\title{Fast Clustering Using Adaptive Density Peak Detection}
\usage{
adpclust(dat, h = NULL, htype = "AMISE", nclust = 2:10,
  centroids = "auto", ac = 1, f.cut = 0.1, fdelta = "mnorm",
  mycols = NULL, dmethod = "euclidean", verbose = FALSE, draw = TRUE,
  findSil = TRUE)
}
\arguments{
\item{dat}{numeric data frame where rows are observations and columns are variables.}

\item{h}{nonnegative number specifying the bandwidth in density estimation NULL (default). If h is NULL, the algorithm will attempt to find h in a neighborhood centered at either the AMISE bandwidth or ROT bandwidth (see htype).}

\item{htype}{character string specifying the method used to calculate a reference bandwidth for the density estimation. 'htype' is ignored if h is not NULL. Currently the two possible choices of 'htype' are "ROT" and "AMISE" (see details).}

\item{nclust}{integer, or integer vector specifying the pool of the number of clusters in automatic variation. Default is 2:10.}

\item{centroids}{character string specifying "user" or "auto" selection of cluster centroids.}

\item{ac}{integer indicating which automatic cut method is used. Currently it takes one of two values:
\itemize{
\item{ac = 1: }{in the f vs. delta decision plot, 'nclust' points with f > percentile f.cut and nclust largest delta's are declaired centroids.}
\item{ac = 2: }{in the f vs. delta decision plot, denote by l the diagonal line connecting the point with smallest f and largest delta, and the point with largest f and smallest delta. 'nclust' points that are above l, and have are farthest away from l are declared centroids.}
}}

\item{f.cut}{number between (0, 1) or numeric vector of numbers between (0,1). f.cut is used in centroids = "auto" to automatically select cluster centroids from the decision plot. Points with f(x) > f.cut and high delta(x) are selected as one set of candidate centroids (see details). Default = c(0.1, 0.2, 0.3).}

\item{fdelta}{character string that specifies the method to estimate densities at each data point. The default (recommended) is "mnorm": multivariate Gaussian density estimation. Other options include
\itemize{
\item{normkernel}{(f <- 1/(h * sqrt(2 * pi)) * rowSums(exp(-(distm/h)^2/2))); Univariate Gaussian smoother}
\item{weighted}{(rho <- rowSums(exp(-(distm/h)^2))); Univariate weighted smoother}
\item{count}{(rho <- rowSums(distm < h) - 1); Histogram estimator (used in Rodriguez [2014])}
}}

\item{mycols}{a vector of character strings specifying colors used to distinguish different cluster. If the number of clusters is larger than length(mycols) then mycols is recycled. The default is NULL, then 9 colors from brewer.pal-Set1 are used.}

\item{dmethod}{character string describing distance measures used in dist() to calculate proximity matrix of dat. This is passed to the argument "method" in dist(). Default = "euclidean"}

\item{verbose}{if TRUE progress will be displayed.}

\item{draw}{if TRUE results will be plotted on screen. Same as plot.adpclust(ans), where 'ans' is the outcome of 'adpclust()'}

\item{findSil}{if FALSE silhouette score is NOT calculated, and the field that stores silhouette is set to -Inf. The default is TRUE. This argument is IGNORED if length(h) == 0 or length(h) > 1 or length(nclust) > 1, as silhouette scores are needed to select the best clustering in these cases.}
}
\value{
An 'adpclust' object, which contains the list of the following items.
\itemize{
\item{f:}{ Final density values (f) for each data point.}
\item{delta:}{ Final delta values for each data point.}
\item{icenters:}{ Indices of the clustering centers.}
\item{clusters}{ Cluster assignments.}
\item{score:}{ Silhouette scores.}
\item{cut.type:}{ Type of cut used in the automatic variation (see 'ac' argument).}
\item{cutvalue:}{ The final best cut value.}
\item{h:}{ Best bandwidth.}
\item{hs:}{ Bandwidths tried in the automatic selection of bandwidth.}
}
}
\description{
Clustering of data by finding cluster centers from estimated density peaks. It is a non-iterative procedure that incorporates multivariate Gaussian density estimation. The number of clusters as well as bandwidths can either be selected by the user or selected automatically through an internal clustering criterion.
}
\details{
Given n data points in p dimensions, adpclust() first finds local density estimation f(x) of each data point x. The bandwidth h used in density estimation can either be explicitly specified by user through the argument 'h', or automatically selected from a range of testing values. In the case of automatic selection of bandwidths, first a reference bandwidth h0 is calculated by one of the two methods: Scott's Rule-of-Thumb value (htype = "ROT") or Wand's Asymptotic-Mean-Integrated-Squared-Error value (htype = "AMISE"), then 10 values equally spread in the range [1/3h0, 3h0] are tested. 

For each data point x, adpclust() also finds an 'isolation' index delta(x), which is defined as the distance between x and the closest point y with f(y) > f(x). The scatter plot (f(x), delta(x)) is called the decision plot. For an appropriate h, cluster centroids appear in the upper-right corner of the decision plot, i.e. points with large f(x) and delta(x). After centroids are picked from the decision plot either by user (centroids = 'user') or automatically (centroids = "auto"), other data points are clustered to the cluster marked by the closest centroid. 

When centroids = 'user', the decision plot is generated and displayed on screen. The user selects centroids by clicking the points on the upper right corner of the decision plot. A right click or ESC ends the selection.
}
\examples{
## Load a data set with 3 clusters
data(clust3)

## Automatically select cluster centroids
ans <- adpclust(clust3, centroids = "auto", draw = FALSE)
summary(ans)
plot(ans)

## Specify the grid of h and nclust
ans <- adpclust(clust3, centroids = "auto", h = c(0.1, 0.2, 0.3), nclust = 2:6)

## Specify that bandwidths should be searched around
## Wand's Asymptotic-Mean-Integrated-Squared-Error bandwidth
## Also test 3 to 6 clusters.
ans <- adpclust(clust3, centroids = "auto", htype = "AMISE", nclust = 3:6)

## Set a specific bandwidth value.
ans <- adpclust(clust3, centroids = "auto", h = 5)

## Change method of automatic selection of centers
ans <- adpclust(clust3, centroids = "auto", nclust = 2:6, ac = 2)

## Specify that the single "ROT" bandwidth value by
## using the 'ROT()' function
ans <- adpclust(clust3, centroids = "auto", h = ROT(clust3))

## Set single h and nclust. Do not calculate silhouette to speed things up
ans <- adpclust(clust3, centroids = "auto", h = ROT(clust3), nclust = 3, findSil = FALSE)

## Centroids selected by user
\dontrun{
ans <- adpclust(clust3, centroids = "user", h = ROT(clust3))
}

## A larger data set
data(clust5)
ans <- adpclust(clust5, centroids = "auto", htype = "ROT", nclust = 3:5)
summary(ans)
plot(ans)
}
\references{
\itemize{
\item{GitHub: \url{https://github.com/ethanyxu/ADPclust}}
\item{Xiao-Feng Wang, and Yifan Xu, (2015) "Fast Clustering Using Adaptive Density Peak Detection." Statistical Methods in Medical Research, doi:10.1177/0962280215609948. }
\item{PubMed: \url{http://www.ncbi.nlm.nih.gov/pubmed/26475830}}
}
}

