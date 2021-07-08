# Sesión 7. RStudio Cloud & GitHub, conexiones con BDs y lectura de datos externos.

# Reto 1. RStudio Cloud & GitHub.


# install.packages("RMySQL")
# install.packages("dplyr")
# install.packages("ggplot2")

library(RMySQL)
library(dplyr)
library(ggplot2)

MyDataBase <- dbConnect(drv = RMySQL::MySQL(),
                        dbname = "shinydemo",
                        host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
                        username = "guest",
                        password = "guest")

dbListTables(MyDataBase)
dbListFields(MyDataBase, 'City')
dbListFields(MyDataBase, 'Country')
dbListFields(MyDataBase, 'CountryLanguage') # Esta es la tabla que se utilizará para
# resolver lo que se pide en las instrucciones del ejercicio.

DataDB <- dbGetQuery(MyDataBase, "SELECT * FROM CountryLanguage;") # Nótese que el
# uso del caracter ";" es indistinto.

str(DataDB) # Se visualiza la naturaleza de los datos.
DataDB$IsOfficial <- as.logical(DataDB$IsOfficial) # Se cambia la tipología de
# la variable "IsOfficial".
SpanLang <- DataDB %>% filter(Language == "Spanish") # Se aplica un filtro para
# conocer cuáles son los países en los que se habla español.

(Percentage.plot <- ggplot(SpanLang, aes(x = Percentage,
                                         y = CountryCode,
                                         fill = IsOfficial)) +
                                                theme_dark() +
         geom_col() + ggtitle("Gráfico de hispanohablantes") +
   labs(x = "% de hablantes", y = "Países de habla hispana") +
   scale_fill_discrete(name = "¿Es lengua\noficial?", labels = c("No", "Sí")))

dbDisconnect(MyDataBase) # Siempre es una buena práctica desconectarse del servidor.