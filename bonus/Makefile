all :
	cd scripts; sudo bash install.sh

clean :
	rm -f scripts/get-docker.sh
	rm -f scripts/get_helm.sh
	rm -f scripts/argocd_passwd
	rm -f scripts/gitlab_passwd
	rm -f scripts/argocd-linux-amd64

fclean: clean
	sudo k3d cluster delete -a

.PHONY : all clean fclean
