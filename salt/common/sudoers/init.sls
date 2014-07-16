sudoers_append:
  file.blockreplace:
    - name: /etc/sudoers
    - marker_start: "## Allows people in group wheel to run all commands"
    - marker_end: "## Allows members of the users group to mount and unmount the "
    - content: |
        %ops            ALL=(ALL)       ALL
        %operations     ALL=(ALL)       ALL
        %iops           ALL=(ALL)       ALL
        %appops         ALL=(ALL)       ALL
        %wheel          ALL=(ALL)       ALL
        %security       ALL=(ALL)       ALL
        %outsourcingOps ALL=(ALL)       ALL
        %idev           ALL=DENYCOMMAND, DENYCOMMAND2, INDIVIDUALS, NETWORKING, SOFTWARE, SERVICES, STORAGE, DELEGATING, PROCESSES, LOCATE, DRIVERS
        %outsourcing    ALL=DENYCOMMAND, DENYCOMMAND2, INDIVIDUALS, NETWORKING, SOFTWARE, SERVICES, STORAGE, DELEGATING, PROCESSES, LOCATE, DRIVERS
        
        ## Same thing without a password
        #%wheel         ALL=(ALL)       NOPASSWD: ALL
        autoOps         ALL=(ALL)       NOPASSWD: ALL
        
        #Defaults    requiretty
    - append_if_not_found: True
    - backup: '.bak'

sudoers_comment:
  file.comment:
    - name: /etc/sudoers
    - regex: ^Defaults    requiretty$