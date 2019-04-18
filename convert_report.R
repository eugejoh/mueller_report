library(here)
library(tesseract)
library(pdftools)
library(magick)
library(dplyr)
library(purrr)
library(readr)

# dl from https://www.npr.org/assets/news/2019/04/muellerreport.pdf

# convert to .png
report <- pdftools::pdf_convert(pdf = here("report_pdf", list.files(here::here("report_pdf"), pattern = "\\.pdf$")),
                                format = "png",
                                pages = NULL,
                                dpi = 600) #high dpi
# create folder for .png files
dir.create(here::here("report_png"))

# move .png files
map2(.x = list.files(here::here(), pattern = "\\.png", full.names = TRUE),
     .y = here::here("report_png", list.files(here::here(), pattern = "\\.png")),
     .f = ~file.rename(from = .x, to = .y))

# run ocr on each .png file
out <- list.files(here::here("report_png"), full.names = TRUE) %>%
  map(~tesseract::ocr(image = ., tesseract(language = "eng")))

# create folder for .rds file
dir.create(here::here("result"))
# save as .rds file
readr::write_rds(x = out, path = here::here("result", "raw_ocr.rds"))