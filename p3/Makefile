all :
	cd scripts; sudo bash install.sh

clean :
	rm -f scripts/get-docker.sh

fclean: clean
	sudo k3d cluster delete -a

.PHONY : all clean fclean
