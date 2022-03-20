my_user_name <- "root"
my_password <- "kungfu"
my_host_name <- "localhost"

library("RMySQL")
library("readODS")

data_path <- "/home/fabio/Documents/automotive_purchase_orders"
data_file <- "data_to_insert.ods"
database_name <- "automotive_purchase_orders"

con <- dbConnect(MySQL(),
                 user=my_user_name,
                 password=my_password,
                 dbname=database_name,
                 host=my_host_name)

dbListTables(con)

order_of_processing <- c(
  "MARCAS",
  "MODELOS",
  "VERSIONES",
  "EQUIPAMIENTOS_OPCIONALES",
  "cruce_VERSIONES_EQUIPA",
  "USADOS",
  "CLIENTES",
  "CONCESIONARIOS",
  "PEDIDOS_NUEVOS",
  "cruce_PEDIDOS_EQUIPA",
  "VENTAS_USADOS"
)

my_tables <- sort(dbListTables(con))
my_sheets <- sort(list_ods_sheets(file.path(data_path,data_file)))
print(my_sheets)
if(!identical(toupper(my_sheets), toupper(my_tables))){
  stop("db tables and ods sheets mismatch")
}else{cat("OK!","\n")}

inserting_data <- function(itable){
  # name of the corresponding ods sheet
  isheet <- grep(paste0("^",itable,"$"), my_sheets, ignore.case=TRUE, value=TRUE)
  # read in the ods sheet
  data_to_insert <- read_ods(
    path = file.path(data_path,data_file),
    sheet = isheet,
    col_names = TRUE, col_types = NA #col_types=NA means 'character'
  )
  # check that field names of table and field names of sheet match
  table_fields <- dbListFields(con,itable)
  sheet_fields <- names(data_to_insert)
  if(itable=="PEDIDOS_NUEVOS"){table_fields <- table_fields[-1]}
  if(!identical(toupper(table_fields), toupper(sheet_fields))){
    stop("Field names of db tables and ods sheets mismatch")
  }
  # loop rows to insert
  for(n in 1:nrow(data_to_insert)){
    statement <- paste0(
      "INSERT INTO ", database_name, ".", itable, " (", paste(table_fields,collapse=","),
      ") VALUES ('", paste(data_to_insert[n,],collapse="','"), "');"
    )
    # insert data and handle messages from db host
    rs <- tryCatch(
      expr = {dbSendStatement(con, statement)},
      error = function(e){
        cat("THERE WAS AN ERROR:","\n")
        cat(e$message,"\n")
        return("Execution interrupted")},
      warning = function(w){
        cat("THERE WAS A WARNING MESSAGE:","\n")
        cat(w$message,"\n")
        return("Execution interrupted")}
    )
    # finalize iteration with error handling
    if(class(rs)!="MySQLResult"){
      cat(statement,"\n"); stop(rs)
    }else{
      dbClearResult(rs); rm(rs)
    }
  }
}

for(i in order_of_processing){
  cat("Processing",i,"\n")
  inserting_data(i)
}

cat("db disconnect",dbDisconnect(con),"\n")
detach("package:RMySQL")
detach("package:DBI")
rm(con)