# --------------------------------------------------------
# Monty Hall Function - Lilian Cheung
# --------------------------------------------------------
# This function simulates n runs of the Monty Hall problem and graphs the results
# You can choose n and whether your strategy is to switch doors (switch=TRUE) or not (switch=FALSE)
# Copy and paste this function into R to define it
test <- FALSE 

Monty <- function( n = 1000, 
                   switch = TRUE ) {

# Initialize the win vector, where we'll store wins
win <- rep(NA, n)

# Define the possible prizes and 'bad prizes' resulting in a loss
prizes <- c("Car", "Goat1", "Goat2")
badprizes <- c("Goat1", "Goat2")

 # Simulation
  for (i in 1:n) {
    
  # Player picks a door randomly
    x <- sample(1:3, 1)
  # Randomly assign each one of the prizes to a 'door' 
    doorsetup <- sample(prizes,3)
    
  # Note: y is the Player's final prize choice, depending on whether Player always switches or always doesn't switch
    
    
    
    # Strategy 1: Player always switches from original choice to the door not revealed by the host
    if(switch) {
      if(doorsetup[x]=="Car") {
        reveal <- sample(badprizes,1)           # If the player's original choice was Car, the host will reveal either Goat1 or Goat2
        revealpos <- which(doorsetup==reveal)   # Location of door revealed by host
      } else if (doorsetup[x]=="Goat1") {
        revealpos <- which(doorsetup=="Goat2")
      } else if (doorsetup[x]=="Goat2") {
        revealpos <- which(doorsetup=="Goat1") }
      y <- doorsetup[-c(x, revealpos)]
    
      
      
    # Strategy 2: Player always stays with original choice, so that no matter what the Host does, the player's final choice will be whatever's behind door x
    } else if (!switch) {
      y <- doorsetup[x]
    }
    
    
    
    # Determine whether player won based on the value of y
    if (y=="Car") {
      win[i] <- 1
    } else {win[i] <- 0}
  }

  n_wins <- sum( win )
  n_losses <- n - sum( win )


  # Print & graph the results of simulation
  data <- data.frame( Result = c("loss","win"), 
                      Count = c( n_losses, n_wins ),
                      Proportion = c( n_losses/n, n_wins/n ),
                      stringsAsFactors = FALSE ) 
  plot <- ggplot( data, 
                  aes( x = Result, 
                       y = Proportion ) ) + 
          geom_bar( stat = "identity" )
  
  list( data = data, 
        plot = plot )
}


if( test == TRUE ) {

### Using the Monty function

# set.seed(123)

# Strategy: You stick with your original door choice
Monty( n = 100000, 
       switch = FALSE )

# Strategy: You stick with your original door choice
Monty( n = 100000, 
       switch = TRUE )

}