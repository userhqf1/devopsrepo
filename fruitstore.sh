#!/bin/bash

# Define a list of items and their prices using an associative array
declare -A ITEMS
ITEMS["Apples"]=3.99
ITEMS["Bananas"]=1.29
ITEMS["Oranges"]=4.49
ITEMS["Grapes"]=2.99
ITEMS["Strawberries"]=5.49
ITEMS["Carrots"]=1.99
ITEMS["Broccoli"]=2.49
ITEMS["Tomatoes"]=3.29
ITEMS["Lettuce"]=1.79
ITEMS["Potatoes"]=2.99

# Function to display the list of available items and their prices
display_items() {
    echo "Available items and prices:"
    # Iterate over the associative array and print each item with its price
    for item in "${!ITEMS[@]}"; do
        printf "%s: $%.2f per pound\n" "$item" "${ITEMS[$item]}"
    done
}

# Function to calculate the total cost based on the order
calculate_total() {
   local total=0  # Initialize total cost to 0
   local item     # Item name from input
   local quantity # Quantity for the item
   local price    # Price of the item

    # Read each item and quantity pair from the input string
    while IFS=":" read -r item quantity; do
        # Get the price of the item from the associative array
        price=${ITEMS[$item]}
        # Calculate the total cost using 'bc' for floating-point arithmetic
        total=$(echo "$total + $price * $quantity" | bc)
    done <<< "$1"  # Pass the input string to the while loop

    # Print the total cost formatted to 2 decimal places
    printf "%.2f" "$total"
}

# Function to handle different payment options
handle_payment() {
    echo "Select a payment method:"
    echo "1. Credit/Debit Card"
    echo "2. Cash"
    echo "3. Online Payment"
    echo "4. Mobile Payment"

    # Prompt user for payment method choice
    read -p "Enter your choice (1-4): " choice
    case $choice in
        1) echo "Credit/Debit Card selected." ;;
        2) echo "Cash selected. Pay upon delivery or pickup." ;;
        3) echo "Online Payment selected. Please follow the instructions on the payment portal." ;;
        4) echo "Mobile Payment selected. Please use your mobile payment app to complete the transaction." ;;
        *) echo "Invalid choice. Please try again." ;;  # Handle invalid input
    esac
}

# Main script execution starts here
echo "Welcome to Sweet Fruits !"
display_items  # Display available items and their prices

# Collect customer order input
declare -A order  # Initialize an associative array to store the order
echo "Enter the items you want to purchase and their quantities (format: item1:quantity item2:quantity ...):"
read -p "Your order: " input  # Read user input for order

# Parse the input and validate items
valid_order=()    # Array to store valid item-quantity pairs
invalid_items=()  # Array to store invalid items or quantities

# Split the input string by spaces into individual item-quantity pairs
IFS=' ' read -r -a items_quantities <<< "$input"
for item_quantity in "${items_quantities[@]}"; do
    item=${item_quantity%%:*}  # Extract item name
    quantity=${item_quantity##*:}  # Extract quantity

    # Validate the item and quantity
    if [[ -n "${ITEMS[$item]}" && $quantity =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        valid_order+=("$item:$quantity")  # Add valid item-quantity pair to the valid_order array
    else
        invalid_items+=("$item_quantity")  # Add invalid item-quantity pair to the invalid_items array
    fi
done

# Report any invalid items or quantities
if [ ${#invalid_items[@]} -gt 0 ]; then
    echo "The following items or quantities are invalid: ${invalid_items[*]}"
fi

# Check if there are no valid items
if [ ${#valid_order[@]} -eq 0 ]; then
    echo "No valid items or quantities were entered. Exiting."
    exit 1  # Exit the script with an error status
fi

# Calculate total cost of the valid order
order_str=$(printf "%s\n" "${valid_order[@]}")
total=$(calculate_total "$order_str")
echo "Your total amount is: \$${total}"

# Handle the payment process
handle_payment

# Final message to the user
echo "Thank you for shopping with us. Your order will be processed. Have a great day!"
