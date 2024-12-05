all :
	vagrant up

s : 
	vagrant ssh ${USER}S

sw :
	vagrant ssh ${USER}SW

clean :
	rm -f node-token *.log

fclean : clean
	vagrant destroy -f

.PHONY : all clean fclean s sw