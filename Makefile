# Set these environment variables according to the 
# release you want to make
# major=17
# minor=02
# sub=8
# rel=1
# local_rel=1
# export lsb_release=16.04
# export lsb_codename=xenial


tld=$(major).$(minor).$(sub)-$(rel)
srcdir=slurm-llnl_$(major).$(minor).$(sub)

orig=$(srcdir).orig

slurm_repo=/home/mrg/Work/Build/slurm-wlm/src/SchedMD/slurm
slurm_tag=slurm-$(major)-$(minor)-$(sub)-$(rel)

deb_repo=git@github.com:FredHutch/packaging-slurm-llnl.git
deb_tag=$(major).$(minor).$(sub)_$(rel)fhcrc$(local_rel)_ubuntu$(lsb_release)
deb_version=$(major).$(minor).$(sub)-$(rel)fhcrc$(local_rel)~ubuntu$(lsb_release)

values:
	@echo "tld:         $(tld)"
	@echo "srcdir:      $(srcdir)"
	@echo "slurm_repo:  $(slurm_repo)"
	@echo "slurm_tag:   $(slurm_tag)"
	@echo "deb_repo:    $(deb_repo)"
	@echo "deb_tag:     $(deb_tag)"
	@echo "deb_version: $(deb_version)"

tld: $(tld)
$(tld):
	mkdir $(tld)

source: $(tld)/$(srcdir)
$(tld)/$(srcdir): $(tld)
	cd $(tld) && git clone $(slurm_repo) $(srcdir)
	cd $(tld)/$(srcdir) && git checkout $(slurm_tag)

# create new deb_version in changelog, tag appropriately
version: 
	-rm -rf .debian-$(deb_tag)
	mkdir -p .debian-$(deb_tag)/debian
	git clone $(deb_repo) .debian-$(deb_tag)/debian
	cd .debian-$(deb_tag)/debian && \
		git checkout $(lsb_codename) ;
	cd .debian-$(deb_tag) && \
		debchange --newversion ${deb_version} \
		--distribution ${lsb_codename} \
		--urgency medium ;
	cd .debian-$(deb_tag)/debian && \
		git commit -m "Add release $(deb_version) to changelog" changelog ;\
		git tag $(deb_tag) ;\
		git push && git push --tags ;\

packaging: $(tld)/$(srcdir)/debian
$(tld)/$(srcdir)/debian:
	cd $(tld)/$(srcdir) && git clone $(deb_repo) debian
	cd $(tld)/$(srcdir)/debian && git checkout $(deb_tag)
	cd $(tld)/$(srcdir)/debian && rm -rf .git .gitignore

plugins: $(tld)/$(srcdir)/src/plugins/job_submit/gizmo-plugins
$(tld)/$(srcdir)/src/plugins/job_submit/gizmo-plugins:
	cd $(tld)/$(srcdir)/src/plugins/job_submit && \
		curl -L https://github.com/atombaby/gizmo-plugins/archive/0.1.1.tar.gz | \
		tar xzf -
	cd $(tld)/$(srcdir)/src/plugins/job_submit && \
		mv gizmo-plugins-0.1.1 gizmo-plugins
	cd $(tld)/$(srcdir) && \
		patch --no-backup-if-mismatch < \
		src/plugins/job_submit/gizmo-plugins/configure.ac.patch && \
		rm src/plugins/job_submit/gizmo-plugins/configure.ac.patch
	cd $(tld)/$(srcdir) && \
		patch --no-backup-if-mismatch -p1 < \
		src/plugins/job_submit/gizmo-plugins/makefile.job_submit.patch && \
		rm src/plugins/job_submit/gizmo-plugins/makefile.job_submit.patch 

tarball: $(tld)/$(srcdir)/$(orig).tar.xz
$(tld)/$(srcdir)/$(orig).tar.xz: $(tld)
	cd $(tld) && tar \
		--exclude=debian \
		--exclude=.gitignore \
		--exclude=.git \
		-c -f $(orig).tar $(srcdir) 
	cd $(tld) && xz --force $(orig).tar 

#deb: $(tld)/$(srcdir) $(tld)/$(srcdir)/src/plugins/job_submit/gizmo-plugins $(tld)/$(srcdir)/debian $(tld)/$(srcdir)/$(orig).tar.xz 
deb:
	cd $(tld)/$(srcdir) && debuild -j4 -us -uc

.PHONY: values
