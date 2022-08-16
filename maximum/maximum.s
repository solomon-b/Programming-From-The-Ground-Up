#PURPOSE: This program finds the maximum number of a
# set of data items.
#
#VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used
# to terminate the data
#
	      .section .data
data_items:
	      .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

	      .section .text

	      .globl _start
_start:
	      movl  $0, %edi                   # Move 0 into the index register
	      movl  data_items(,%edi,4), %eax # Load the first byte of data
	      movl  %eax, %ebx                 # Since this is the first item. %eax holds the largest value

start_loop:
	      cmpl  $0, %eax                   # Check if we have hit the end of the list
	      je    loop_exit
	      incl  %edi                       # Increment the index
	      movl  data_items(,%edi,4), %eax  # Load the next byte of data
	      cmpl  %ebx, %eax                 # Compare values
	      jle   start_loop                 # Jump to start of loop of %ebx is larger then %eax
	      movl  %eax, %ebx                 # Else move %eax to %ebx.
	      jmp   start_loop                 # And jump to start of loop

loop_exit:
movl $1, %eax                   # Set status code to 1
int $0x80
