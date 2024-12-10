variable "required_tags" {
    description = "Tags required to be specified on all resources"
    type = object({ 
      environment = string
      OwnerEmail = string
      Session = string
      Subsystem = string
      Backup = string
      Organization = string 
    })

    validation { 
      condition = var.required_tags.environment !="" && var.required_tags.environment == lower(var.required_tags.environment) && contains(["dev" , "test" , "prod", "uat"], var.required_tags.environment)
    error_message = "Enviroment must be a non-empty value and must be lowercase, and must be one of -dev,test,prod,uat."   
    }

     validation {
      condition = var.required_tags.OwnerEmail !="" && var.required_tags.OwnerEmail == lower(var.required_tags.OwnerEmail)
    error_message = "Owneremail must be a non-empty value and must be lowercase." 
    }

     validation {
      condition = var.required_tags.Session !=null && var.required_tags.Session == lower(var.required_tags.Session)
    error_message = "Session must be a non-empty value and must be lowercase." 
    }

    validation {
      condition = var.required_tags.Subsystem == lower(var.required_tags.Subsystem) && var.required_tags.Subsystem !=""
    error_message = "Subsystem must be lowercase and cannot be empty."
    }

    validation {
      condition = (var.required_tags.Backup == "yes" || var.required_tags.Backup == "no") && var.required_tags.Backup == lower(var.required_tags.Backup)
    error_message = "Backup must be either 'yes' or 'no' and must be lowercase."
   }

   validation {
  condition     = length(var.required_tags.Organization) <= 8 && var.required_tags.Organization !=""
  error_message = "Organization must be a string with a maximum of 8 characters."
}

  
}