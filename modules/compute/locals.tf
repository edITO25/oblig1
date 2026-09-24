locals {
  computer_name = substr(replace(var.base_name, "-", ""), 0, 15)
}

//Windows godtar maks 15 tegn i computer_name og ingen bindestreker 
//replace() fjerner bindestreker 
//substr() klipper til 15 tegn 