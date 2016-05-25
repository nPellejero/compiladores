long var = 4;
int func2(int a);

int func1(int a){
	func2(a);
	return a+1;
}
int func2(int a){
	func1(a);
	return a+2;
}


int main(){
	func1(3);
return 0;
}
