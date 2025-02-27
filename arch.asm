
# Data segment
.data
file_loc: .asciiz "C:\\Users\\Admin\\Desktop\\Arch_project\\medical.txt"

message2: .asciiz "No unnormal tests found based on that id number"
message3: .asciiz "No unnormal tests found"
POINT41: .asciiz "The average value for Hgb test is "
POINT42: .asciiz "The average value for BGT test is "
POINT43: .asciiz "The average value for LDL test is "
POINT441: .asciiz "The average value for BPT Systolic Blood Pressure  test is "
POINT442: .asciiz "The average value for BPT Diastolic Blood Pressure test is "

wrong_option: .asciiz "Enter a number from 1 to 5 only.\n"
menuTitle: .asciiz "\n************ medical records ************\n\n"
option1: .asciiz "1) show all tests\n"
option2: .asciiz "2) Add a new medical test\n"
option3: .asciiz "3) Search for a test by patient ID\n"
option4: .asciiz "4) Search for unnormal tests\n"
option5: .asciiz "5) find Average test value\n"
option6: .asciiz "6) Update an existing test result\n"
option7: .asciiz "7) Delete an appointment\n"
option8: .asciiz "8) Exit program and save changes\n\n"
enter: .asciiz "Enter option number\n"
enter_patient_number: .asciiz "1) Enter patient number\n"
testing: .asciiz "HIIIIIIIII"
message1: .asciiz "No tests were found with that ID number "
fileWords: .space 2048
colon: .asciiz ":"
zero: .asciiz "0"
dash: .asciiz "-"
comma: .asciiz ","
space:.asciiz " "
newLine: .asciiz "\n"
formatted_data_length: .word 40

# Constants for input validation
patient_id_length: .word 7
max_patient_id_length: .word 8
max_test_name_length: .word 4
max_test_date_length: .word 8
max_buffer_length: .word 1024
max_month: .word 3
max_year: .word 5
.line_length: .word 30   # Define line_length as 30 characters
max_test_month_length: .word 4

float_0_1: .float 0.1
float_1_0: .float 1.0
float_0_0: .float 0.0
buffer: .space 20
id_buffer: .space 20
test_name_buffer : .space 20
year_buffer : .space 20
month_buffer : .space 20
year2_buffer : .space 20
month2_buffer : .space 20
result_buffer : .space 20
result2_buffer : .space 20
yearFile_buffer: .space 20
monthFile_buffer: .space 20
target1: .asciiz "Hgb"
target2: .asciiz "BGT"
target3: .asciiz "LDL"
target4: .asciiz "BPT"
test_file_name: .asciiz "medical_tests.txt"
# Define the normal ranges for test results
Hgb_min: .float 13.8
Hgb_max: .float 17.2
BGT_min: .float 70
BGT_max: .float 99
LDL_max: .float 100
LDL_min: .float 1
BPT_min1: .float 120
BPT_min2: .float 80
zeroAsFloat: .float 0.0


prompt_patient_id: .asciiz "Enter Patient ID (7 digits): "
prompt_test_name: .asciiz "\nEnter Test name:\n"
prompt_month: .asciiz "\nEnter Test month (MM):"
prompt_year: .asciiz "Enter Test year (YYYY):\n"
prompt_test_result: .asciiz "Enter Test result:\n"
invalid_id_message: .asciiz "Invalid ID. Please enter a 7-digit integer.\n"
error_invalid_test_name: .asciiz "\nInvalid test name. Please enter one of the following: Hgb, BGT, LDL, BPT.\n"
invalid_month_message: .asciiz "Invalid month. Please enter a valid month.\n"
invalid_year_message: .asciiz "Invalid year. Please enter a valid year.\n"
error_invalid_result: .asciiz "Please enter a positive result value.\n"
success_message: .asciiz "The data has been written in the file.\n"
num0: .asciiz "Choose one of the following options\n"
num1: .asciiz "1) Retrieve all patient tests\n"
num2: .asciiz "2) Retrieve all up normal patient tests\n"
num3: .asciiz "3) Retrieve all patient tests in a given specific period"
num4: .asciiz "Sorry, there is no test found based on your id"
noDate: .asciiz "Sorry, there is no test found in this given period"
abnormal_test_message: .asciiz "unnormal test found"
program_complete_message: .asciiz "The program is finished"
 normal_tests_message: .asciiz "All tests are normal"
 delete_msg: .asciiz "Enter the test number you want to delete as (1,2,3,....)\n "
update_msg: .asciiz "Enter the test number you want to update as (1,2,3,....)\n "
wrong_option_msg: .asciiz "wrong option\n"
op1: .asciiz "1) Update test name\n"
op2: .asciiz "2) Update test date\n"
op3: .asciiz "3) Update test result\n"
prompt_test_result1: .asciiz "Enter Systolic Blood Pressure Test result:\n"
prompt_test_result2: .asciiz "Enter Diastolic Blood Pressure Test result:\n"


 .macro print_string (%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro


# Text segment
.text
show_tests:
    li $v0, 13                  # open_file syscall code = 13
    la $a0, file_loc            # get the file location
    li $a1, 0                   # file flag = read (0)
    syscall
    move $s0, $v0              

   
    li $v0, 14                  # read_file syscall code = 14
    move $a0, $s0               # file descriptor
    la $a1, fileWords           # The buffer that holds the string of the WHOLE file
    la $a2, 1024                
    syscall

    # Close the file
    li $v0, 16                  
    move $a0, $s0           
    syscall


     la $a0, newLine          
    la $a1, fileWords           # Load address of fileWords buffer into $a1
    jal strcopier
    nop


main:  #The menu and options
    print_string(menuTitle)
    print_string(option1)
    print_string(option2)
    print_string(option3)
    print_string(option4)
    print_string(option5)
    print_string(option6)
    print_string(option7)
    print_string(option8)
    print_string(enter)

    # Accept user input for menu choice
    li $v0, 5                  
    syscall
    move $t0, $v0

    beq $t0, 1, show_all
    beq $t0, 2, add_test
    beq $t0, 3, search_test
    beq $t0,4,search_unNormalTest
    beq $t0,5,average_testValue
    beq $t0,6,update_test
    beq $t0,7,delete_option
    beq $t0,8,exit_program 
     j wrong_option_entered     
   
show_all:
   print_string(fileWords)
   j main


add_test:
    # Prompt for Patient ID
    li $v0, 4                   
    la $a0, prompt_patient_id
    syscall

    # Read Patient ID
    li $v0, 8                   
    la $a0, id_buffer
    lw $a1, max_patient_id_length   # Maximum number of characters to read
    syscall

    # Validate Patient ID
    la $t0, id_buffer              
    li $t1, 0                   
    j check_digit_loop

check_digit_loop:
    lb $t2, 0($t0)              
    beq $t2, $zero, check_digit_end 
    li $t3, 0x30               
    li $t4, 0x39               
    blt $t2, $t3, invalid_id   
    bgt $t2, $t4, invalid_id
    addi $t0, $t0, 1           
    addi $t1, $t1, 1
    j check_digit_loop         

check_digit_end:
    bne $t1, 7, invalid_id     # If number of digits is not 7, invalid ID
input_test:
    # Prompt for Test name
    li $v0, 4                   
    la $a0, prompt_test_name    
    syscall

    # Read Test name
    li $v0, 8                   
    la $a0, test_name_buffer              
    lw $a1, max_test_name_length    
    syscall


# Compare with target1 (Hgb)
    la $t0, target1     
    la $t1, test_name_buffer       
    jal compare_strings 
    la $t6, 0
    bne $v0, $zero, name_valid

    # Compare with target2 (BGT)
    la $t0, target2    
    la $t1, test_name_buffer     
    jal compare_strings
    la $t6, 0
    bne $v0, $zero, name_valid 

    # Compare with target3 (LDL)
    la $t0, target3     
    la $t1, test_name_buffer       
    jal compare_strings 
    la $t6, 0
    bne $v0, $zero, name_valid

    # Compare with target4 (BPT)
    la $t0, target4     
    la $t1, test_name_buffer       
    jal compare_strings
    la $t6, 1
    bne $v0, $zero, name_valid

    # No match found
    li $v0, 4           
    la $a0, error_invalid_test_name 
    syscall
    j input_test             


name_valid:
    # Prompt for Month
    li $v0, 4                   
    la $a0, prompt_month        
    syscall

    # Read Month
    li $v0, 5                   
    syscall
    move $a0, $v0              
   
    # Validate Month
    li $t0, 1                
    li $t1, 12                
    blt $a0, $t0, invalid_month 
    bgt $a0, $t1, invalid_month 
    
    
    
la   $a1, month_buffer             
jal  int2str              # call int2

input_year:
    # Prompt for Year
    li $v0, 4                  
    la $a0, prompt_year         
    syscall

    # Read Year
    li $v0, 5                   
    syscall
    move $a0, $v0               
    
    # Validate Year
    li $t2, 2000               
    li $t3, 2024                
    blt $a0, $t2, invalid_year  
    bgt $a0, $t3, invalid_year 
    
    
    la   $a1, year_buffer            
jal  int2str              # call int2str

    # Prompt for Test result
    li $v0, 4                   
    la $a0, prompt_test_result  
    syscall

    # Read Test result
    li $v0, 6
    li $v0, 8                  
    la $a0, result_buffer
    lw $a1, max_patient_id_length   # Maximum number of characters to read
    syscall
    
    #Adding the new medical test to the fileWords buffer
   
    la $a0, id_buffer               
    la $a1, fileWords          
    jal strcopier
    nop
    
    la $a0, colon               
    la $a1, fileWords          
    jal strcopier
    nop

	
     la $a0, space               
    la $a1, fileWords           
    jal strcopier
    nop


     la $a0, test_name_buffer              # Load address of dash into $a0
    la $a1, fileWords           # Load address of fileWords buffer into $a1
    jal strcopier
    nop
    
  la $a0, comma             # Load address of dash into $a0
    la $a1, fileWords           # Load address of fileWords buffer into $a1
    jal strcopier
    nop

   la $a0, space             
    la $a1, fileWords           
    jal strcopier
    nop
    
     la $a0, year_buffer            
    la $a1,   fileWords        
    jal strcopier
    nop


    la $a0, dash            
    la $a1,   fileWords       
    jal strcopier
    nop

la $t4, month_buffer   # Load the address of month_buffer into $t4

# Load the ASCII value of the first character of the string into $t5
lb $t5, ($t4)

# Convert ASCII to integer ('0' - '9' ASCII values are 48 - 57)
sub $t5, $t5, 48

# Load the ASCII value of the second character of the string into $t6
lb $t6, 1($t4)

# Convert ASCII to integer for the second character
sub $t6, $t6, 48

# If the month is already two digits long, jump to X1
beq $t5, 1, X1

# Check if the month is less than 10
li $t1, 10
blt $t5, $t1, X

X1:   
      la $a0, month_buffer            
    la $a1,   fileWords        
    jal strcopier
    nop
    
    la $a0, comma            
    la $a1,   fileWords        
    jal strcopier
    nop

    la $a0, space            
    la $a1,   fileWords        
    jal strcopier
    nop

    la $a0, result_buffer         
    la $a1,   fileWords        
    jal strcopier
    nop  
    
     beq $t6, 1 , input_second_value
        
    j main                      # Return to the main menu
    #**************************************************************
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>POINT #2
search_test:
     print_string(num0)
     print_string(num1)
     print_string(num2)
     print_string(num3)
     
     # Accept user input for menu choice
    li $v0, 5                   
    syscall
    move $t0, $v0

    beq $t0, 1, retrieve_patientTests
    beq $t0,2,retrieve_upNormalTest
    beq $t0, 3, Retrieve_PatientsTests_IngivenPeriod
retrieve_patientTests:     
    # Prompt for Patient ID
    li $v0, 4                  
    la $a0, prompt_patient_id
    syscall

    # Read Patient ID
    li $v0, 8                   
    la $a0, id_buffer
    lw $a1, max_patient_id_length   
    syscall
 
    la $a3, fileWords
 li $t6, 0   
# Loop through the buffer
search_loop:
    # Load a character from the buffer
    la $a1, id_buffer
    lb $t1, 0($a3)
    move $t2,$a3
    # Check for end of string (null terminator)
    beqz $t1, end_search
    beq $t1, 10, B1 #new line check
    j id_match_loop
id_match_loop:
    lb $t4, 0($a3)       
    lb $t5, 0($a1)       
    # Compare characters
    beq $t4, ':', id_match_found1   
    beq $t4, $t5, id_char_match    
    j search_next_test              
id_char_match:
    addi $a3, $a3, 1     
    addi $a1, $a1, 1    
    j id_match_loop      

id_match_found1:
addi $t6,$t6,1
     li $v0, 4           
    la $a0, newLine
    syscall             
id_match_found:
    lb $t0, 0($t2)         
    beq $t0, 0, end_search   
    beq $t0, 10, B1 
    li $v0, 11             
    move $a0, $t0           
    syscall               
    addi $t2, $t2, 1    
    j id_match_found            # Repeat the loop
    
search_next_test:
    addi $a3, $a3, 1     # Move to next character in the buffer
    lb $t1, 0($a3)
    beq $t1, 10, search_loop
    beqz $t1,end_search
    j search_next_test  # Continue searching for newline character

B1:
 addi $a3, $a3, 1
 j search_loop
 
B2:
addi $a3, $a3, 1
lb $t1, 0($a0)
beq $t1, 10,B1
j B2
end_search:
beqz $t6,NoTests
  
j main

NoTests:
li $v0, 4           
    la $a0, newLine
    syscall
print_string(message1)
    j main
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ POINT 2.2
retrieve_upNormalTest:
 # Prompt for Patient ID
    li $v0, 4                   
    la $a0, prompt_patient_id
    syscall

    # Read Patient ID
    li $v0, 8                   
    la $a0, id_buffer
    lw $a1, max_patient_id_length   
    syscall
    
    la $s6,fileWords  #for id
     la $a0, fileWords #for name
    la $a3, fileWords #for result
    la $a1, test_name_buffer
    la $a2, result_buffer
    la $t9,result2_buffer 
    li $s7,1
    search_loopP2:
    # Load a character from the buffer
    la $t8, id_buffer
    lb $t1, 0($s6)
    move $t2,$s6
    # Check for end of string (null terminator)
    beqz $t1, end_searchP2
    beq $t1, 10, B1P2
    j id_match_loopP2
id_match_loopP2:
    lb $t4, 0($s6)      
    lb $t5, 0($t8)       

    # Compare characters
    beq $t4, ':', id_match_found1P2  
    beq $t4, $t5, id_char_matchP2    
    j search_next_testP2                 
id_char_matchP2:
    addi $s6, $s6, 1     
    addi $t8, $t8, 1     
    j id_match_loopP2      # Continue comparing characters

id_match_found1P2:
   #  li $v0, 4           # System call code for printing string
  #  la $a0, newLine
    #syscall             # Execute system call 
id_match_foundP2:
addi $t6,$t6,1
move $a3,$t2
move $a0,$t2
li $s7,1
j read_testName
search_next_testP2:
    addi $s6, $s6, 1     # Move to next character in the buffer
    lb $t1, 0($s6)
    beq $t1, 10, search_loopP2
    beqz $t1,end_searchP2
    j search_next_testP2  # Continue searching for newline character

B1P2:
 addi $s6, $s6, 1
 j search_loopP2
 
B2P2:
addi $s6, $s6, 1
lb $t1, 0($s6)
beq $t1, 10,B1P2
j B2P2
end_searchP2:

    j main



#$$$$$$$$$$$$$ POINT 2.3
Retrieve_PatientsTests_IngivenPeriod:

    # Prompt for Patient ID
    li $v0, 4                   # Print string syscall
    la $a0, prompt_patient_id
    syscall

    # Read Patient ID
    li $v0, 8                   # Read string syscall
    la $a0, id_buffer
    lw $a1, max_patient_id_length   # Maximum number of characters to read
    syscall
         # Prompt for month1
    li $v0, 4                   # Print string syscall
    la $a0, prompt_month
    syscall

    # Read month1
    li $v0, 8                   # Read string syscall
    la $a0, month_buffer
    lw $a1, max_month   # Maximum number of characters to read
    syscall
    
           # Prompt for year1
    li $v0, 4                   # Print string syscall
    la $a0, prompt_year
    syscall

    # Read year1
    li $v0, 8                   # Read string syscall
    la $a0, year_buffer
    lw $a1, max_year   # Maximum number of characters to read
    syscall
          # Prompt for month2
    li $v0, 4                   # Print string syscall
    la $a0, prompt_month
    syscall

    # Read month2
    li $v0, 8                   # Read string syscall
    la $a0, month2_buffer
    lw $a1, max_month   # Maximum number of characters to read
    syscall
          # Prompt for year2
    li $v0, 4                   # Print string syscall
    la $a0, prompt_year
    syscall

    # Read year2
    li $v0, 8                   # Read string syscall
    la $a0, year2_buffer
    lw $a1, max_year   # Maximum number of characters to read
    syscall
    
    li $v0, 13                  # open_file syscall code = 13
    la $a0, file_loc            # get the file name
    li $a1, 0                   # file flag = read (0)
    syscall
    move $s0, $v0               # save the file descriptor

    # read the file
    li $v0, 14                  # read_file syscall code = 14
    move $a0, $s0               # file descriptor
    la $a1, fileWords           # The buffer that holds the string of the WHOLE file
    la $a2, 1024                # hardcoded buffer length
    syscall
 

      # Load address of the fileWords buffer into a register
la $s6, fileWords

# Load the entered patient ID into a register
la $a1, month_buffer
la $a2, year_buffer
la $a3,month2_buffer
la $t0,year2_buffer
li $t6,0
search_loop1:
    # Load a character from the buffer
   la $t1,id_buffer
    lb $t2, 0($s6)
    move $t3,$s6
    # Check for end of string (null terminator)
    beqz $t2, end_search1
    beq $t2, 10, B11
    j id_match_loop1
id_match_loop1:
    lb $t4, 0($s6)       # Load a character from the buffer
    lb $t5, 0($t1)       # Load a character from the entered ID buffer

    # Compare characters
    beq $t4, ':', id_found1   # If ':' is encountered, end of patient ID in buffer
    beq $t4, $t5, id_char_match1    # If characters match, continue comparing
    j search_next_test1                  # If characters don't match, no match
id_char_match1:
    addi $s6, $s6, 1     # Move to next character in the buffer
    addi $t1, $t1, 1     # Move to next character in the entered ID buffer
    j id_match_loop1      # Continue comparing characters
id_found1:
addi $s6,$s6,5
la $t4,yearFile_buffer
id_match_found2:

    lb $t2, 0($s6)  
    beq $t2, 45, is_dash  
     sb $t2, 0($t4)
    # Move to the next character
    addi $s6, $s6, 1
    addi $t4, $t4, 1
    j id_match_found2
is_dash:
     ble $a2, $t4, rule1   # Branch if year_buffer <= yearFile_buffer
point3:
   addi $s6,$s6,1
lb $t2,($s6)
beq $t2, 10, point31
j point3

point31:
addi $s6,$s6,1
j search_loop1
rule1:

bge $t4, $t0, yearFound
j point3


yearFound:
la $t5,monthFile_buffer
addi $s6,$s6,1
 lb $t2, 0($s6)  
    beq $t2, 44, is_comma3  #here mean we stored the month value 
     sb $t2, 0($t5)
    # Move to the next character
    addi $s6, $s6, 1
    addi $t5, $t5, 1
j yearFound

is_comma3:
blt $t4,$t0,monthFound1
#beq $t0,$,is_comma2

is_comma2:
ble $a2, $t5, ruleMonth   # Branch if year_buffer <= yearFile_buffer
point32:
   addi $s6,$s6,1
lb $t2,($s6)
beq $t2, 10, point34
j point32

point34:
addi $s6,$s6,1
j search_loop1
ruleMonth:
bge $t5, $t0, monthFound1
j point3

monthFound1:
li $v0, 11      # Load the system call code for printing a character
li $a0, 10      # Load the ASCII value for the newline character into $a0
syscall         # Execute the system call to print the newline character

monthFound:
addi $t6,$t6,1
 lb $t2, 0($t3)          # Load the byte at the address in $t1
    beq $t2, 0, end_search1   # If the byte is null (end of string), exit the loop
    beq $t2, 10, B11  # If the byte is a newline character, exit the loop
    li $v0, 11              # System call code for printing a character
    move $a0, $t2          # Move the character to $a0 for printing
    syscall                 # Print the character
    addi $t3, $t3, 1        # Move to the next character in memory
    j monthFound     

search_next_test1:
    addi $s6, $s6, 1     # Move to next character in the buffer
    lb $t2, 0($s6)
    beq $t2, 10, search_loop1
    beqz $t2,end_search1
    j search_next_test1  # Continue searching for newline character

B11:
#lw $a0, 0($sp)        # Restore $a0 from the stack
#addi $sp, $sp, 16
 addi $s6, $s6, 1
 j search_loop1
 
end_search1:
#lw $a0, 0($sp)        # Restore $a0 from the stack
#addi $sp, $sp, 16
beqz $t6,NoTests1
    # Close the file
    li $v0, 16                  # close_file syscall code
    move $a0, $s0               # file descriptor to close
    syscall
j main
NoTests1:
li $v0, 4           # System call code for printing string
    la $a0, newLine
    syscall
    print_string(noDate)
     li $v0, 16                  # close_file syscall code
    move $a0, $s0               # file descriptor to close
    syscall
j main
# >>>>>>>>>>>>>>>>>>>>>>>>POINT #3
search_unNormalTest:
    la $a0, fileWords
    la $a3, fileWords
    la $a1, test_name_buffer
    la $a2, result_buffer
    la $t9,result2_buffer
    
   POINT4:
beqz $t0,end_avgValue    
j H1
read_loop:
read_testName:
li $s5,0
    lb $t0, 0($a0)
    move $t7,$a0
    # Load the first character of the test name
    lb $t0, 9($a0)
    beq $s0,1,POINT4
H1:
  
     beqz $t0, end_unNormaltests    
     
    # Load the second character of the test name
    lb $t1, 10($a0)
    # Load the third character of the test name
    lb $t2, 11($a0)
    # Store the characters in the test_name_buffer
    sb $t0, ($a1)    # Store the first character
    sb $t1, 1($a1)   # Store the second character
    sb $t2, 2($a1)   # Store the third character
    addi $a0, $a0, 19
    #Now we stored the test name in the buffer (for first line)
 
N1:
addi $a0, $a0, 1
lb $t1,($a0)
beq $t1, '\n', N2
j N1

N2:
addi $a0, $a0, 1
addi $a3,$a3,23
li $t8,0
read_result:
    lb $t0, 0($a3)  
    beq $t0, 44, is_comma1    
    # Copy the character to the destination buffer
    sb $t0, 0($a2)
    # Move to the next character
    addi $a3, $a3, 1
    addi $a2, $a2, 1
     beq $t0, '\n', end_copy1
    j read_result
is_comma1:
addi $t8,$t8,1
is_comma:
 addi $a3, $a3, 1
  lb $t0, 0($a3) 
  sb $t0, 0($t9) 
  addi $a3, $a3, 1
    addi $t9, $t9, 1
     beq $t0, '\n', end_copy1
     j is_comma
#Now we have the test name and test result stored in buffers
end_copy1:  
   
     # Compare with target1 (Hgb)
    la $t0, target1     
    la $t1, test_name_buffer        
    jal compare_strings
    beq $s0,1,Hgb1_branch1
   
    bne $v0, $zero, Hgb_branch
Hgb1_branch1:
bne $v0, $zero, Hgb1_branch 

    # Compare with target2 (BGT)
    la $t0, target2    
    la $t1, test_name_buffer       
    jal compare_strings 
    beq $s0,1,BGT1_branch1
    bne $v0, $zero, BGT_branch 
BGT1_branch1:
bne $v0, $zero, BGT1_branch 
    # Compare with target3 (LDL)
    la $t0, target3     
    la $t1, test_name_buffer        
    jal compare_strings 
    beq $s0,1,LDL1_branch1
    bne $v0, $zero, LDL_branch
LDL1_branch1:
bne $v0, $zero, LDL1_branch
    # Compare with target4 (BPT)
    la $t0, target4     
    la $t1, test_name_buffer        
    jal compare_strings 
    beq $s0,1,BPT1_branch1
    bne $v0, $zero, BPT_branch
BPT1_branch1:
bne $v0, $zero, BPT1_branch
Hgb_branch:
li $s4, 1
  lwc1 $f2, Hgb_min   
    lwc1 $f4, Hgb_max
j check_result
D1:
c.lt.s $f4, $f0
bc1t below_min_OR_above_max
c.lt.s $f0, $f2
bc1t below_min_OR_above_max

C2:
lw $a3, 12($sp)       # Restore $a3 from the stack
lw $a2, 8($sp)        # Restore $a2 from the stack
lw $a1, 4($sp)        # Restore $a1 from the stack
lw $a0, 0($sp)        # Restore $a0 from the stack
addi $sp, $sp, 16     # Restore the stack pointer to its original position
beq $s7,1,B2P2
j read_testName

BGT_branch:
li $s4, 2
  lwc1 $f2, BGT_min   
    lwc1 $f4, BGT_max
j check_result
D2:
c.lt.s $f4, $f0
c.eq.s $f5, $f0    
bc1t below_min_OR_above_max
c.lt.s $f0, $f2
bc1t below_min_OR_above_max

j C2

LDL_branch:
li $s4, 3 
    lwc1 $f2, LDL_min   
    lwc1 $f4, LDL_max
j check_result
D3: 
c.lt.s $f4, $f0
bc1t below_min_OR_above_max
c.lt.s $f0, $f2
bc1t below_min_OR_above_max
j C2

BPT_branch:
li $s4, 4 
lwc1 $f2, BPT_min1   
    lwc1 $f4, BPT_min2
    j check_result
D4:
c.eq.s $f2, $f0    
 bc1t D44
 j D444
D44: 
 c.eq.s $f8, $f4    
 bc1t C2
    c.lt.s $f4,$f8
    bc1t below_min_OR_above_max
    j C2
    
D444:
 c.lt.s $f2,$f0
    bc1t below_min_OR_above_max
    c.eq.s $f8, $f4    
 bc1t C2
 c.lt.s $f4,$f8
    bc1t below_min_OR_above_max
       
j C2
check_result:
la $a2, result_buffer
la $t9,result2_buffer
# Save register values to the stack
addi $sp, $sp, -16    # Adjust stack pointer to make space for 4 registers
sw $a0, 0($sp)        # Save $a0 to the stack
sw $a1, 4($sp)        # Save $a1 to the stack
sw $a2, 8($sp)        # Save $a2 to the stack
sw $a3, 12($sp)       # Save $a3 to the stack


   j convert_string_to_float
   
   convert_string_to_float:
    # Process the string in $a2
    li $t1, 0            # Initialize $t1 to store integer part
    li $t2, 0            # Initialize $t2 to store decimal part
    l.s $f0, float_0_0   # Initialize $f0 to store final float result
    li $t3, -1           # Initialize $t3 to store position of decimal point
    li $t4, 0            # Initialize $t4 to store power of 10 for decimal part

l.s $f6, float_0_0


    # Loop to process each character of the string
    loop_a2:
        lb $t0, 0($a2)       
        beqz $t0, end_loop_a2  

        # Check if it's a digit or decimal point
        li $t5, 48           
        li $t6, 57          
        beq $t0, 46, check_decimal_a2   
        blt $t0, $t5, next_char_a2      
        bgt $t0, $t6, next_char_a2

        # Convert character to integer
        sub $t0, $t0, $t5   
        mul $t1, $t1, 10    
        add $t1, $t1, $t0    

        # Continue looping
        j next_char_a2

    # Check if the current character is a decimal point
    check_decimal_a2:
        beq $t3, -1, set_decimal_position_a2  
        j next_char_a2

    # Set the position of the decimal point
    set_decimal_position_a2:
        move $t3, $t1         
        j next_char_a2

    # Move to the next character
    next_char_a2:
        addi $a2, $a2, 1
        j loop_a2

    # End of loop for string in $a2
    end_loop_a2:

    # Calculate the final float value for string in $a2
    sub $t4, $t1, $t3      # Calculate the decimal part length
    l.s $f1, float_0_1     # Load floating point value 0.1
    mtc1 $t1, $f6          # Move integer part to floating point register
    cvt.s.w $f6, $f6       # Convert integer part to floating point

    # Convert the decimal part to float if it exists
    convert_decimal_to_float_a2:
        blez $t4, end_convert_decimal_a2  
        mul.s $f0, $f0, $f1   
        mul $t4, $t4, 10      
        subi $t4, $t4, 1      
        j convert_decimal_to_float_a2

    # End conversion of decimal part for string in $a2
    end_convert_decimal_a2:

    # Multiply integer part by power of 10
    mul.s $f6, $f6, $f1    # Multiply integer part by power of 10
    add.s $f0, $f0, $f6    # Add integer part to floating point result

    # Process the string in $t9 if t8 equals 1
    beq $t8, 1, convert_string_t9
    j end_convert_string_to_float

convert_string_t9:
   
    # Process the string in $a2
    li $t1, 0            # Initialize $t1 to store integer part
    li $t2, 0            # Initialize $t2 to store decimal part
    l.s $f8, float_0_0   # Initialize $f0 to store final float result
    li $t3, -1           # Initialize $t3 to store position of decimal point
    li $t4, 0            # Initialize $t4 to store power of 10 for decimal part

l.s $f6, float_0_0
    # Loop to process each character of the string
    loop_t9:
        lb $t0, 0($t9)       
        beqz $t0, end_loop_t9   

        # Check if it's a digit or decimal point
        li $t5, 48           
        li $t6, 57           
        beq $t0, 46, check_decimal_t9  
        blt $t0, $t5, next_char_t9   
        bgt $t0, $t6, next_char_t9

        # Convert character to integer
        sub $t0, $t0, $t5    
        mul $t1, $t1, 10    
        add $t1, $t1, $t0    

        # Continue looping
        j next_char_t9

    # Check if the current character is a decimal point
    check_decimal_t9:
        beq $t3, -1, set_decimal_position_t9  # Set decimal position if it's not already set
        j next_char_t9

    # Set the position of the decimal point
    set_decimal_position_t9:
        move $t3, $t1          
        j next_char_t9

    # Move to the next character
    next_char_t9:
        addi $t9, $t9, 1
        j loop_t9

    # End of loop for string in $a2
    end_loop_t9:

    # Calculate the final float value for string in $a2
    sub $t4, $t1, $t3      # Calculate the decimal part length
    l.s $f1, float_0_1     # Load floating point value 0.1
    mtc1 $t1, $f6          # Move integer part to floating point register
    cvt.s.w $f6, $f6       # Convert integer part to floating point

    # Convert the decimal part to float if it exists
    convert_decimal_to_float_t9:
        blez $t4, end_convert_decimal_t9  # End loop if no decimal part
        mul.s $f8, $f8, $f1    # Multiply current float result by 0.1
        mul $t4, $t4, 10      
        subi $t4, $t4, 1       
        j convert_decimal_to_float_t9

    # End conversion of decimal part for string in $a2
    end_convert_decimal_t9:

    # Multiply integer part by power of 10
    mul.s $f6, $f6, $f1    # Multiply integer part by power of 10
    add.s $f8, $f8, $f6    # Add integer part to floating point result
end_convert_string_to_float:
beq $s0,1, goToPoint4
    beq $s4,1,D1
    beq $s4,2,D2
    beq $s4,3,D3
    beq $s4,4,D4

goToPoint4:

 beq $s4,1,L1
    beq $s4,2,L2
    beq $s4,3,L3
    beq $s4,4,L4

    
below_min_OR_above_max:

    j unNormal_TestFound1
    
unNormal_TestFound1:
li $v0, 4           
    la $a0, newLine
    syscall 
    j unNormal_TestFound
unNormal_TestFound:
li $k0,1
lb $t0, 0($t7)          
    beq $t0, 0, end_unNormaltests   
    beq $t0, 10, C1  
    li $v0, 11             
    move $a0, $t0         
    syscall                 # Print the character
    addi $t7, $t7, 1        # Move to the next character in memory
    j unNormal_TestFound           # Repeat the loop

C1:
lw $a3, 12($sp)       # Restore $a3 from the stack
lw $a2, 8($sp)        # Restore $a2 from the stack
lw $a1, 4($sp)        # Restore $a1 from the stack
lw $a0, 0($sp)        # Restore $a0 from the stack
addi $sp, $sp, 16     # Restore the stack pointer to its original position
   beq $s7,1,B2P2
       j read_testName

end_unNormaltests:
# Restore register values from the stack
lw $a3, 12($sp)       # Restore $a3 from the stack
lw $a2, 8($sp)        # Restore $a2 from the stack
lw $a1, 4($sp)        # Restore $a1 from the stack
lw $a0, 0($sp)        # Restore $a0 from the stack
addi $sp, $sp, 16     # Restore the stack pointer to its original position
bne $k0,1,notFound
    j main
notFound:
li $v0, 4           
    la $a0, newLine
    syscall
print_string(message3)
    j main
    #<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>  POINT 6
average_testValue:  
    la $a0, fileWords
    la $a3, fileWords
    la $a1, test_name_buffer
    la $a2, result_buffer
    la $t9,result2_buffer

li $s0, 1  #here we defined this to mark this point
l.s $f2, float_0_0
l.s $f3, float_0_0
l.s $f4, float_0_0
l.s $f5, float_0_0



l.s $f9, float_0_0   #To increment by 1
l.s $f10, float_0_0
l.s $f11, float_0_0
l.s $f13, float_0_0

l.s $f15,float_0_0
l.s $f17,float_1_0
j read_loop

Hgb1_branch:
li $s4,1
j check_result
L1:   
add.s $f2, $f2, $f0   
 
add.s $f9,$f9,$f17

lw $a3, 12($sp)       # Restore $a3 from the stack
lw $a2, 8($sp)        # Restore $a2 from the stack
lw $a1, 4($sp)        # Restore $a1 from the stack
lw $a0, 0($sp)        # Restore $a0 from the stack
addi $sp, $sp, 16     # Restore the stack pointer to its original position
j read_loop

BGT1_branch:
li $s4,2
j check_result
L2:
add.s $f3, $f3, $f0   
add.s $f10,$f10,$f17
lw $a3, 12($sp)       # Restore $a3 from the stack
lw $a2, 8($sp)        # Restore $a2 from the stack
lw $a1, 4($sp)        # Restore $a1 from the stack
lw $a0, 0($sp)        # Restore $a0 from the stack
addi $sp, $sp, 16     # Restore the stack pointer to its original position
j read_loop

LDL1_branch:
li $s4,3
j check_result
L3:
add.s $f4, $f4, $f0   
add.s $f11,$f11,$f17 
lw $a3, 12($sp)       # Restore $a3 from the stack
lw $a2, 8($sp)        # Restore $a2 from the stack
lw $a1, 4($sp)        # Restore $a1 from the stack
lw $a0, 0($sp)        # Restore $a0 from the stack
addi $sp, $sp, 16     # Restore the stack pointer to its original position
j read_loop

BPT1_branch:
li $s4,4
j check_result
L4:
li $v0, 2         
mov.s $f12, $f0    
syscall
add.s $f5, $f5, $f0    
li $v0, 2         
mov.s $f12, $f5    
syscall
add.s $f7, $f7, $f8    
add.s $f13,$f13,$f17
lw $a3, 12($sp)       # Restore $a3 from the stack
lw $a2, 8($sp)        # Restore $a2 from the stack
lw $a1, 4($sp)        # Restore $a1 from the stack
lw $a0, 0($sp)        # Restore $a0 from the stack
addi $sp, $sp, 16     # Restore the stack pointer to its original position
j read_loop


end_avgValue:
c.eq.s $f9, $f15   
bc1f Hgb_print    

c.eq.s $f10, $f15   
bc1f BGT_print   

c.eq.s $f9, $f15 
bc1f LDL_print  

c.eq.s $f9, $f15 
bc1f BPT_print   

j main
Hgb_print:
print_string(POINT41)
  div.s $f14, $f2, $f9
  li $v0, 2          
mov.s $f12, $f14 
syscall            

li $v0, 11       
li $a0, 10         
syscall        
####
c.eq.s $f10, $f15   
bc1f BGT_print    

c.eq.s $f11, $f15   
bc1f LDL_print    

c.eq.s $f13, $f15   
bc1f BPT_print  

j main
####
BGT_print:
print_string(POINT42)
 div.s $f14, $f3, $f10
  li $v0, 2          
mov.s $f12, $f14    
syscall           

li $v0, 11         
li $a0, 10      
syscall          
####
c.eq.s $f11, $f15   
bc1f LDL_print    

c.eq.s $f13, $f15   
bc1f BPT_print    


j main
####
LDL_print:
      
   print_string(POINT43)
 div.s $f14, $f4, $f11
  li $v0, 2         
mov.s $f12, $f14    
syscall            

li $v0, 11         
li $a0, 10        
syscall          
####


c.eq.s $f13, $f15   
bc1f BPT_print    


j main
####
BPT_print:
    print_string(POINT441)
 div.s $f14, $f5, $f13
  li $v0, 2          
mov.s $f12, $f14    
syscall            

li $v0, 11         # System call code for printing a character
li $a0, 10         # ASCII value for new line
syscall            # Perform the system call to print the new line

print_string(POINT442)
 div.s $f14, $f7, $f13
  li $v0, 2          
mov.s $f12, $f14   
syscall          

li $v0, 11         
li $a0, 10         
syscall            # Perform the system call to print the new line
 
j main

####POINT 6 (UPDATE test)

update_test:
    # Display menu for update options
    print_string(option6)
    print_string(op1)
    print_string(op2)
    print_string(op3)
    print_string(enter)

    # Accept user input for update choice
    li $v0, 5                   # Read integer syscall
    syscall
    move $t0, $v0
    
    

    # Based on the user's choice, perform the corresponding update functionality
    beq $t0, 1, update_test_name
    beq $t0, 2, update_test_date
    beq $t0, 3, update_test_result
  
    
    j wrong_option_entered      # Handle wrong option entered
    
    
update_test_name:

print_string(update_msg)
 
 print_string(fileWords)
    
    # Accept user input for the line number to update
    li $v0, 5                   # Read integer syscall
    syscall
    move $a1, $v0
 # Load address of fileWords buffer into $a0 
la $a0, fileWords

    li $t0, 0            # $t0 will be used as a counter


# Check if user input is 0 (for current line)
sub $a1,$a1, 1

    beq $a1, $zero, found_current_linee# If user input is 0, directly go to found_current_line

find_newlinee:
    lb $t3, 0($a0)       # Load a byte from the buffer
    beq $t3, 10, found_newlinee # Check if it's a newline character
    addi $a0, $a0, 1     # Move to the next byte
    j next_charr          # Jump to next character

found_newlinee:
    addi $t0, $t0, 1     # Increment the newline counter
    beq $t0, $a1, found_nth_newlinee # Check if it's the nth newline character
    addi $a0, $a0, 1     # Move to the next byte

next_charr:
    j find_newlinee       # Repeat until newline is found

found_nth_newlinee:
    addi $a0, $a0, 1   # Move to the beginning of the next line (second line)
   
    j enddd

found_current_linee:

    # Do nothing, as we are already at the beginning of the current line
enddd:    
  # Load address of the buffer into a register
    la $t0, fileWords
 move $t0, $a0   # Copy the value in $a0 to temporary register $t0
    addi $t0, $t0, 9  
    
      # Prompt for new test name
    li $v0, 4                   
    la $a0, prompt_test_name    
    syscall

    # Read new test name
    li $v0, 8                   
    la $a0, test_name_buffer    # Buffer to store new test name
    lw $a1, max_test_name_length # Maximum number of characters to read
    syscall
    
    lb $t1, 0($a0)    # Load byte at offset 0 from address stored in $a0 into $t
    sb $t1, 0($t0)    
    addi $t0, $t0, 1
    lb $t1, 1($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)    
    addi $t0, $t0, 1
    lb $t1, 2($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)   

j main                    # Return to the main menu


update_test_date:
print_string(update_msg)
 
 print_string(fileWords)
    
    # Accept user input for the line number to delete
    li $v0, 5                   # Read integer syscall
    syscall
    move $a1, $v0
 # Load address of fileWords buffer into $a0 
la $a0, fileWords
    li $t0, 0            # $t0 will be used as a counter

# Check if user input is 0 (for current line)
sub $a1,$a1, 1

    beq $a1, $zero, found_current_linee2# If user input is 0, directly go to found_current_line

find_newlinee2:
    lb $t3, 0($a0)       # Load a byte from the buffer
    beq $t3, 10, found_newlinee2# Check if it's a newline character
    addi $a0, $a0, 1     # Move to the next byte
    j next_charr2         # Jump to next character

found_newlinee2:
    addi $t0, $t0, 1     # Increment the newline counter
    beq $t0, $a1, found_nth_newlinee2# Check if it's the nth newline character
    addi $a0, $a0, 1     # Move to the next byte

next_charr2:
    j find_newlinee2       # Repeat until newline is found

found_nth_newlinee2:
    addi $a0, $a0, 1   # Move to the beginning of the next line (second line)
   
    j enddd2

found_current_linee2:

    # Do nothing, as we are already at the beginning of the current line
    j enddd2   
enddd2:    
   
  # Load address of the buffer into a register
    la $t0, fileWords
 move $t0, $a0   # Copy the value in $a0 to temporary register $t0
    addi $t0, $t0, 14 
    
      # Prompt for new test name
    li $v0, 4                   # Print string syscall
    la $a0, prompt_year   # Prompt for new test name
    syscall

    # Read new test name
    li $v0, 8                   # Read string syscall
    la $a0, year_buffer    # Buffer to store new test name
    lw $a1, max_test_date_length# Maximum number of characters to read
    syscall
    
    lb $t1, 0($a0)    # Load byte at offset 0 from address stored in $a0 into $t
    sb $t1, 0($t0)  
    addi $t0, $t0, 1
    lb $t1, 1($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)    
    addi $t0, $t0, 1
    lb $t1, 2($a0)    # Load byte at offset 2 from address stored in $a0 into $t2
    sb $t1, 0($t0)    
    addi $t0, $t0, 1
    lb $t1, 3($a0)    # Load byte at offset 3 from address stored in $a0 into $t2
    sb $t1, 0($t0)    
    
  addi $t0, $t0, 2 
  
      # Prompt for new test name
    li $v0, 4                   # Print string syscall
    la $a0, prompt_month  # Prompt for new test name
    syscall

    # Read new test name
    li $v0, 8                  
    la $a0, month_buffer    
    lw $a1, max_test_month_length
    syscall
    
     lb $t1, 0($a0)    # Load byte at offset 0 from address stored in $a0 into $t
    sb $t1, 0($t0)    
    addi $t0, $t0, 1
    lb $t1, 1($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)   
    subi $t0, $t0, 1 
    
j main    
                                                                                   
update_test_result:
 
print_string(update_msg)
 
 print_string(fileWords)
    
    # Accept user input for the line number to delete
    li $v0, 5                   # Read integer syscall
    syscall
    move $a1, $v0
 # Load address of fileWords buffer into $a0 
la $a0, fileWords
    li $t0, 0            # $t0 will be used as a counter

# Check if user input is 0 (for current line)
sub $a1,$a1, 1

    beq $a1, $zero, found_current_linee3# If user input is 0, directly go to found_current_line

find_newlinee3:
    lb $t3, 0($a0)       # Load a byte from the buffer
    beq $t3, 10, found_newlinee3# Check if it's a newline character
    addi $a0, $a0, 1     
    j next_charr3        # Jump to next character

found_newlinee3:
    addi $t0, $t0, 1     # Increment the newline counter
    beq $t0, $a1, found_nth_newlinee3# Check if it's the nth newline character
    addi $a0, $a0, 1   

next_charr3:
    j find_newlinee3      # Repeat until newline is found

found_nth_newlinee3:
    addi $a0, $a0, 1  # Move to the beginning of the next line (second line)
   
    j enddd3

found_current_linee3:

    # Do nothing, as we are already at the beginning of the current line
    j enddd3   
    
enddd3:    

  # Load address of the buffer into a register
    la $t0, fileWords
     move $t0, $a0   # Copy the value in $a0 to temporary register $t0
 
    addi $t0, $t0, 23
   
  
      # Prompt for new test name
    li $v0, 4                   # Print string syscall
    la $a0, prompt_test_result  # Prompt for new test name
    syscall

    # Read new test name
    li $v0, 8                   # Read string syscall
    la $a0, result_buffer    
    lw $a1, max_test_name_length# Maximum number of characters to read
    syscall
    
     lb $t1, 0($a0)    # Load byte at offset 0 from address stored in $a0 into $t
    sb $t1, 0($t0)   
    addi $t0, $t0, 1
    lb $t1, 1($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)  
    addi $t0, $t0, 1
    lb $t1, 2($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)   
     addi $t0, $t0, 1
    lb $t1, 3($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)    
    addi $t0, $t0, 1
    lb $t1, 4($a0)    # Load byte at offset 1 from address stored in $a0 into $t2
    sb $t1, 0($t0)   
    
j main                    # Return to the main menu

#********************************************************
invalid_id:
    # Handle invalid Patient ID
    li $v0, 4                   # Print string syscall
    la $a0, invalid_id_message  # Print error message
    syscall
    j add_test



invalid_month:
    # Handle invalid month
    li $v0, 4                   # Print string syscall
    la $a0, invalid_month_message  # Print error message
    syscall
    j name_valid

invalid_year:
    # Handle invalid year
    li $v0, 4                   # Print string syscall
    la $a0, invalid_year_message  # Print error message
    syscall
    j input_year


strcopier:
    or $t0, $a0, $zero          # Source
    or $t1, $a1, $zero          # Destination

    # Find the end of the destination buffer
    move $t2, $t1               # Copy the destination buffer pointer to $t2
find_end_loop:
    lb $t3, 0($t2)              # Load byte from destination buffer
    beqz $t3, end_find_end      # If byte is null terminator, end loop
    addiu $t2, $t2, 1           # Move to next byte
    j find_end_loop             # Repeat loop
    nop

end_find_end:
    # Copy the new string to the end of the destination buffer
copy_new_string:
    lb $t3, 0($t0)              # Load byte from source buffer
    beq $t3, $zero, end_copy    # If byte is null terminator, end copy
    sb $t3, 0($t2)              # Store byte to destination buffer
    addiu $t0, $t0, 1           # Move to next byte in source buffer
    addiu $t2, $t2, 1           # Move to next byte in destination buffer
    j copy_new_string           # Repeat copy
    nop

end_copy:
    # Append null terminator to the destination buffer
    li $t3, 0                    # Null terminator
    sb $t3, 0($t2)               # Store null terminator at the end of destination buffer

    # Return the pointer to the end of the destination buffer
    move $v0, $t2
    jr $ra
    nop
        
  # inputs : $a0 -> integer to convert
#          $a1 -> address of string where converted number will be kept
# outputs: none
int2str:
addi $sp, $sp, -4         # to avoid headaches save $t- registers used in this procedure on stack
sw   $t0, ($sp)           # so the values don't change in the caller. We used only $t0 here, so save that.
bltz $a0, neg_num         # is num < 0 ?
j    next0                # else, goto 'next0'

neg_num:                  # body of "if num < 0:"
li   $t0, '-'
sb   $t0, ($a1)           # *str = ASCII of '-' 
addi $a1, $a1, 1          # str++
li   $t0, -1
mul  $a0, $a0, $t0        # num *= -1

next0:
li   $t0, -1
addi $sp, $sp, -4         # make space on stack
sw   $t0, ($sp)           # and save -1 (end of stack marker) on MIPS stack

push_digits:
blez $a0, next1           # num < 0? If yes, end loop (goto 'next1')
li   $t0, 10              # else, body of while loop here
div  $a0, $t0             # do num / 10. LO = Quotient, HI = remainder
mfhi $t0                  # $t0 = num % 10
mflo $a0                  # num = num // 10  
addi $sp, $sp, -4         # make space on stack
sw   $t0, ($sp)           # store num % 10 calculated above on it
j    push_digits          # and loop

next1:
lw   $t0, ($sp)           # $t0 = pop off "digit" from MIPS stack
addi $sp, $sp, 4          # and 'restore' stack

bltz $t0, neg_digit       # if digit <= 0, goto neg_digit (i.e, num = 0)
j    pop_digits           # else goto popping in a loop

neg_digit:
li   $t0, '0'
sb   $t0, ($a1)           # *str = ASCII of '0'
addi $a1, $a1, 1          # str++
j    next2                # jump to next2

pop_digits:
bltz $t0, next2           # if digit <= 0 goto next2 (end of loop)
addi $t0, $t0, '0'        # else, $t0 = ASCII of digit
sb   $t0, ($a1)           # *str = ASCII of digit
addi $a1, $a1, 1          # str++
lw   $t0, ($sp)           # digit = pop off from MIPS stack 
addi $sp, $sp, 4          # restore stack
j    pop_digits           # and loop

next2:
sb  $zero, ($a1)          # *str = 0 (end of string marker)

lw   $t0, ($sp)           # restore $t0 value before function was called
addi $sp, $sp, 4          # restore stack
jr  $ra                   # jump to caller


compare_strings:
    lb $t2, 0($t0)      # Load a character from target string
    lb $t3, 0($t1)      # Load a character from input string
    beq $t2, $zero, end_compare # If end of target string, exit comparison
    beq $t3, $zero, end_compare # If end of input string, exit comparison
    bne $t2, $t3, not_equal # If characters are not equal, jump to not_equal
    addi $t0, $t0, 1    # Increment target string pointer
    addi $t1, $t1, 1    # Increment input string pointer
    j compare_strings   # Continue comparison

not_equal:
    li $v0, 0           # Set return value to indicate strings are not equal
    jr $ra              # Return from subroutine

end_compare:
    li $v0, 1           # Set return value to indicate strings are equal
    jr $ra              # Return from subroutine
    
compare_strings1:
    lb $t2, 0($t0)      # Load a character from target string
    lb $t3, 0($t1)      # Load a character from input string
    beq $t2, $zero, end_compare1 # If end of target string, exit comparison
    beq $t3, $zero, end_compare1 # If end of input string, exit comparison
    bne $t2, $t3, not_equal # If characters are not equal, jump to not_equal
    addi $t0, $t0, 1    # Increment target string pointer
    addi $t1, $t1, 1    # Increment input string pointer
    j compare_strings1   # Continue comparison

end_compare1:
    li $v0, 1           # Set return value to indicate strings are equal
    jr $ra              # Return from subroutine
    
input_second_value:
 print_string(prompt_test_result2)
     li $v0, 8                   # Read string syscall
    la $a0, result_buffer
    lw $a1, max_patient_id_length   # Maximum number of characters to read
    syscall
    
    	la $a0, comma            # Load address of dash into $a0
    la $a1,   fileWords        # Load address of fileWords buffer into $a1
    jal strcopier
    nop

 la $a0, result_buffer            # Load address of dash into $a0
    la $a1,   fileWords        # Load address of fileWords buffer into $a1
    jal strcopier
    nop
j main

delete_option:
 print_string(delete_msg)
 
 print_string(fileWords)
    
    # Accept user input for the line number to delete
    li $v0, 5                   # Read integer syscall
    syscall
    move $a1, $v0
 # Load address of fileWords buffer into $a0 with an offset of 1
# Load address of fileWords buffer into $a0 with an offset of 1
la $a0, fileWords


    li $t0, 0            # $t0 will be used as a counter



# Initialize counter
    li $t0, 0            # $t0 will be used as a counter

# Load user input (which newline character to find)
    # Assuming $a1 contains the user input

# Check if user input is 0 (for current line)
sub $a1,$a1, 1

    beq $a1, $zero, found_current_line # If user input is 0, directly go to found_current_line

find_newline:
    lb $t3, 0($a0)       # Load a byte from the buffer
    beq $t3, 10, found_newline # Check if it's a newline character
    addi $a0, $a0, 1     # Move to the next byte
    j next_char          # Jump to next character

found_newline:
    addi $t0, $t0, 1     # Increment the newline counter
    beq $t0, $a1, found_nth_newline # Check if it's the nth newline character
    addi $a0, $a0, 1     # Move to the next byte

next_char:
    j find_newline       # Repeat until newline is found

found_nth_newline:
    addi $a0, $a0, 1     # Move to the beginning of the next line (second line)
    j end

found_current_line:
    # Do nothing, as we are already at the beginning of the current line
    j end

end:
    # End of the code



# Load address of the dash label into temporary register $t0
la $t0, space        

# Load the value from the memory location pointed to by $t0 into $t1
lb $t1, 0($t0)       

# Store the value in $t1 to the memory location pointed to by $a0 30 times
li $t2, 27
loop1:
    sb $t1, 0($a0)      # Store the value in $t1 to the memory location pointed to by $a0

    # Increment buffer pointer
    addi $a0, $a0, 1

    # Decrement loop counter
    addi $t2, $t2, -1

    # Check loop condition
    bnez $t2, loop1
   


j main

exit_program:
    # Add code to exit the program
    li $v0, 10                  # Exit syscall
    syscall

wrong_option_entered:
    # Handle case where wrong option is selected
    print_string(wrong_option_msg)
    j main                      # Return to the main menu
    
X: 
    la $a0,zero
     la $a1,fileWords        
    jal strcopier
    nop
    j X1