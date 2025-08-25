library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
timeseries <- model$timeseries[model$timeseries$Era == "TIME",]

# Calculate F by season
f.season <- timeseries
f.season <- f.season[c("Area", "Yr", "Seas", grepv("F:_", names(f.season)))]

# Convert wide to long format
# Area|Yr|Seas|0|1|2|...|N
# Area|Yr|Seas|Age|Value
x <- f.season

wide2long <- function(x, names=c("Age", "Value"))
{
  cols <- grepv("[0-9]", names(x), invert=TRUE)
  rowlab <- apply(x[cols], 1, paste, collapse = "|")
  x <- x[!names(x) %in% cols]
  names(x) <- sub("[^0-9]+([0-9]+)", "\\1", names(x))
  row.names(x) <- rowlab
  x <- as.data.frame(as.table(as.matrix(x)), stringsAsFactors=FALSE)
  x[[2]] <- type.convert(as.character(x[[2]]), as.is=TRUE)
  left <- read.table(text=x[[1]], sep = "|", col.names=cols)
  x$Var1 <- NULL
  names(x) <- names
  x <- cbind(left, x)
  x
}

z1 <- wide2long(f.season, c("Age", "F"))
z2 <- pivot_longer(f.season, cols=starts_with("F:_"), names_to="Age",
                   names_prefix="F:_", values_to="F")
z2 <- as.data.frame(z2)
z1 <- z1[order(z1$Area, z1$Yr, z1$Seas, z1$Age),]
z2 <- z2[order(z2$Area, z2$Yr, z2$Seas, z2$Age),]
row.names(z1) <- NULL
row.names(z2) <- NULL


identical(z1, z2)
