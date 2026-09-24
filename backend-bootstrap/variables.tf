variable "shortname" {
  type = string
  description = "Mine initialer, for å sikre unikhet i backend ressursnavn"
}

variable "location" {
  type = string
  description = "geografisk plassering av backend ressurser"
}

variable "subscription_id" {
  type        = string
  default     = null
  description = "Settes bare hvis du har flere subscriptions, står den som null, brukes ARM_SUBSCRIPTION_ID eller den aktive subscriptionen fra az account show"
}

