all :
	cd scripts; bash install.sh

clean :
	rm -f scripts/get-docker.sh

fclean: clean
	k3d cluster delete -a

.PHONY : all clean fclean