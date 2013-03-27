nf_queue_test : nf_queue_test.c
	gcc $< -o $@ -lnetfilter_queue

clean :
	rm -f nf_queue_test
