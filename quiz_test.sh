#!/bin/bash

sign_up ()

{
    
    header   
    echo -e "\e[92m<<<<<\e[0m Signup \e[92m>>>>>\e[0m"
    users=(`cat user_name.csv`) 
    echo "Enter Username:"
    read username
    
    for user in `seq 0 $((${#users[@]}-1))`
    do
	userid=${users[$user]}

  
    if [ $userid = $username ] 
    then
	echo -e "\e[31mUsername already exists! Plase use different username.\e[0m"
	sign_up   
    fi
    done
    pw=1
    while [ $pw -ne 0 ]	
    do
    	echo "Enter Password: "
    	read password
    #	echo "length ${#password}"
	if [ ${#password} -lt 6 ] 
	then
	    echo -e "\e[31mPlease use atleast 6 character of password.\e[0m"
	else
	    pw=0
	fi
    done
    pass=1
    attempts=4
    while [ $pass -ne 0 -a $attempts -ne 0 ]
    do
	echo "Confirm Password: "
	read conf_password
	if [ $conf_password = $password ] 
	then
	    pass=0
	    echo -e "\e[32mCongratulation! Your Username & Password Created Successfully!\e[0m"
	    
    	    echo $username >> user_name.csv  
	    echo $conf_password >> password.csv 
	    welcome
	else
	    attempts=$(($attempts-1)) 
	    echo -e "\e[31mWrong Password! Remaining Attempts\e[0m = $attempts"

	    if [ $attempts -eq 0 ] 
	    then
		echo -e "\e[31mSorry! You crossed your maximum limit.\e[0m"
		echo "Signup Again!"
		sign_up
	    fi
	fi
    done

}

sign_in ()

{
   
    header
    echo -e "\e[32m<<<<<\e[0m Signin \e[32m>>>>>\e[0m"
    users=(`cat user_name.csv`)  
    found=0
    attempts=4 
    while [ $found -ne 1 -a $attempts -ne 0 ]
    do
	echo -e "\e[34mEnter Username:\e[0m "
	read login_user
	for user in `seq 0 $((${#users[@]}-1))`
	do
	    #echo ${users[$user]} 

	    if [ ${users[$user]} = $login_user ] 
	    then
		found=1
		position=$user 
        #echo "User: $position"
	    fi
	done
	if [ $found -eq 1 ]
	then
	    echo -e "\e[92m:) Great!\e[0m"
	else
	    echo -e "\e[31mUsername does't exist\e[0m"
	    attempts=$(($attempts-1)) 
	    if [ $attempts -gt 0 ]
	    then
		echo "Please try again"
		echo "You have $attempts attempts remaining"
	    else
		echo -e "\e[31mSorry! You crossed your maximum limit.\e[0m"
		echo "Plaease Signup again"
	       welcome  
	    fi
	fi
    done	

    password=(`cat password.csv`)   
    attempts=4
    found=0
    while [ $found -ne 1 -a $attempts -ne 0 ]
    do
	echo -e "\e[34mEnter Password:\e[0m "
	read login_pass
	echo
	#echo "Position: $position"  
	#echo "Pass Position: ${password[$position]}"
	if [ ${password[$position]}=$login_pass ]  
	then
	 #   echo "Password Matched"
	    echo -e "\e[92mLogin Successful! You can start your exam.\e[0m"
	    start_test 
	    found=1
	else
	    echo -e "\e[31mWrong Password! Plase try again.\e[0m"
	    attempts=$(($attempts-1))  
	    if [ $attempts -gt 0 ]
	    then
		echo "You have $attempts attempts remaining"
	    else
		echo -e "\e[31mSorry! No more attempts. Please try latter\e[0m"
		welcome 
	    fi
	fi

    done
}

start_test ()
{
    header
    echo -e "1) \e[32mTake the Test\e[0m"
    echo -e "2) \e[31mExit\e[0m"
    echo
    read -p "Enter your choice: " choice 
    line=`cat question_bank.txt | wc -l`  
    
    case $choice in
	1)
	    for i in `seq 5 5 $line` 
	    do
		#clear
		#sleep 2s
		header
		echo
		head -$i question_bank.txt | tail -5  
		echo
		for j in `seq 10 -1 1` # ti
		do
		    echo -e "\r\e[31mEnter the currect answer\e[0m \e[32m$j\e[0m : \c" 
		    read -t 1 ans 
		    if [ ${#ans} -ne 0 ]
		    then
			break
		    fi  
		done
	#	echo "word count: ${#ans}"
		    
	#	read -p "Choose the currect answer : " ans
		if [ ${#ans} -eq 1 ]
		then
		echo "$ans" >> user_answer.txt  
	        else
		echo "No_Answer" >> user_answer.txt #
		fi
		echo

		#echo "Next Question"
	    done

	    
	;;
	
        2)
	    exit
	;;
	
    	*) echo -e "\e[31mPlease choose currect option.\e[0m"
	   start_test
    esac
    results
}

results ()

{
    header
    c_ans=(`cat currect_answer.txt | tr -s ' ' | cut -d ':' -f1`) 
    c_ans1=(`cat currect_answer.txt | tr -s ' ' | cut -d ':' -f2`) 
    u_ans=(`tail -5 user_answer.txt`) 
    #echo "${c_ans[@]}"
    #echo "${u_ans[@]}"
    score=0
   
    for i in `seq 0 $((${#c_ans[@]}-1))`
    do
	if [ ${c_ans[i]} = ${u_ans[i]} ] 
	then
	    echo -e "Q$(($i+1))) Your answer is : \e[32m${c_ans[i]} (Correct)\e[0m"
            echo -e "\e[32mQ$(($i+1)))\e[0m \e[34mCurrect answer is :\e[0m \e[32m${c_ans[i]}. ${c_ans1[i]}\e[0m"
	    echo
	    score=$(($score+1)) 
	else
	    echo -e "Q$(($i+1))) Your answer is : \e[31m${u_ans[i]} (Incorrect)\e[0m"
	    echo -e "\e[32mQ$(($i+1)))\e[0m \e[34mCurrect answer is :\e[0m \e[32m${c_ans[i]}. ${c_ans1[i]}\e[0m"
	    echo
	fi
    done
	echo -e "\e[32mYour Total Score\e[0m: $score Marks"
	echo
	exit
    
}

header ()

{   sleep 2s   
    clear  
	echo ____________________________________________________
    	echo
    	echo -e "\e[32m<<<<<<<<<<<<<<<<<\e[0m \e[1;4mOnline MCQ Test\e[0m \e[32m>>>>>>>>>>>>>>>>>\e[0m"
	echo -e "\e[31mTotal Marks\e[0m : 5                    \e[31mTime\e[0m : 50 Seconds"
	echo ____________________________________________________

}
#header

welcome ()
{
    	header
    	echo -e "1.\e[92mSignup\e[0m"
	echo -e "2.\e[92mSignin\e[0m"
	echo -e "3.\e[92mExit\e[0m"
	echo

	read -p "Please choose option : " choice

	case $choice in
   		1) echo -e "\e[92mGreat! You are ready to Signup.\e[0m"
		    sign_up
		   ;;

	        2) echo -e "\e[92mGreat! You are ready to Signin.\e[0m"
		    sign_in
		    ;;

       		3) exit
		    ;;

		*) echo -e "\e[91mPlease choose currect option\e[0m"
		    welcome
		    ;;

	esac

}

welcome
#start_test
#results
