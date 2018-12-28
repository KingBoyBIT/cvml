import tensorflow as tf

g1 = tf.Graph()
with g1.as_default():
	# 在计算图G1中定义变量v，初值为0
	v = tf.get_variable("v", initializer=tf.zeros_initializer()(shape=[1]))

g2=tf.Graph()
with g2.as_default():
	v = tf.get_variable("v", initializer=tf.ones_initializer()(shape=[1]))

with tf.Session(graph=g1) as sess:
	tf.global_variables_initializer().run()
	with tf.variable_scope("",reuse=True):
		print(sess.run(tf.get_variable("v")))

with tf.Session(graph=g2) as sess:
	tf.global_variables_initializer().run()
	with tf.variable_scope("",reuse=True):
		print(sess.run(tf.get_variable("v")))



a =tf.constant([1.0,2.0],name=  "a")
b =tf.constant([1,2],name="b",dtype=tf.float32)

result = a+b
