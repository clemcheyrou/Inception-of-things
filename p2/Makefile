all :
	vagrant up

s : 
	vagrant ssh ${USER}S

clean :
	rm -f node-token *.log

fclean : clean
	vagrant destroy -f

.PHONY : all clean fclean s