all :
	cd scripts; sudo bash install.sh

clean :
	rm -f scripts/get-docker.sh
	rm -f scripts/argocd_passwd

fclean: clean
	sudo k3d cluster delete -a

.PHONY : all clean fclean
