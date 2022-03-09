credential_db <- function()
    structure(new.env(parent = emptyenv()), class = "credential_db")

get_credential <- function(credentials, dsn) UseMethod("get_credential")

get_credential.credential_db <- function(credentials, dsn) {
    if (!exists(dsn, envir = credentials)) return(NULL)
    mycred <- get(dsn, envir = credentials)
    mycred$PWD <- decrypt(mycred$PWD)
    mycred
}

set_credential <- function(credentials, dsn, uid, pwd, ) UseMethod("set_credential")
set_credential.credential_db <- function(credentials, dsn, uid, pwd) {
    encrypted_password <- encrypt(pwd)
    assign(dsn,
           list(
               UID = uid,
               PWD = encrypted_password
           ),
           envir = credentials)
    invisible(credentials)
}

encrypt <- function(pwd) {
    key <- get_secret_passphrase()
    spwd <- serialize(pwd, NULL)
    
    sodium::data_encrypt(spwd, key)
}

decrypt <- function(encrypted_pwd) {
    key <- get_secret_passphrase()
    unserialize(sodium::data_decrypt(encrypted_pwd, key))
}

secret_passphrase <- function() {
    pw <- NULL
    function() {
        if (is.null(pw)) {
            plain <- .rs.askForPassword("Please enter your secret passphrase")
            pw <<- sodium::hash(charToRaw(plain))
        }
        pw
    }
}

get_secret_passphrase <- secret_passphrase()
