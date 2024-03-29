//////////////////////////////////////////////////////////////////////////////////
// Name: An-Ting Hsu
// Student ID: 103061207
//
// Create Date:    2015/06/05 00:57:12
// Purpose:    Convert the words from binary to hexadecimal.
// Project Name:   Word Converter
//
//////////////////////////////////////////////////////////////////////////////////
#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
using namespace std;

void process_word(string, ofstream &);

int main()
{
	ifstream inFile;
	inFile.open("BitFont.txt");

	if(!inFile){
		cout << "Input file \"BitFont.txt\" is not valid." << endl << endl;
		exit(-1);
	}

	string word;
	int word_count = 0;
	ofstream outFile;
	outFile.open("LCD_Words.v");

	if(!outFile){
        cout << "Fail to create the file!!" << endl;
        exit(-1);
    }

    outFile << "`timescale 1ns / 1ps" << endl << endl << "//LCD words" << endl;
	getline(inFile, word);
	while(!word.empty()){
		process_word(word, outFile);
		getline(inFile, word);
	}

	outFile.close();
	inFile.close();

	cout << "Convert Finished!!! (In LCD_Words.v)" << endl << endl;
	system("LCD_Words.v");
	system("pause");

	return 0;
}

void process_word(string word1, ofstream &outFile)
{
	string word2, word_tmp;
	int tmp, comma_pos;

	//Search ","
	for(int i=0; i<word1.size(); i++){
		if(word1[i] == ','){
			comma_pos = i;
			break;
		}
	}
	word2 = word2.assign(word1, comma_pos+1, 256);

	outFile << "`define LCD_";
	for(int i=0; i<comma_pos; i++){
		outFile << word1[i];
	}
	outFile << " 256'h";

	for(int i=0; i<word2.size(); i+=4){
		word_tmp = word_tmp.assign(word2, i, 4);
		tmp = atoi(word_tmp.c_str());

		switch(tmp)
		{
			case 0: outFile << "0"; break;
			case 1: outFile << "1"; break;
			case 10: outFile << "2"; break;
			case 11: outFile << "3"; break;
			case 100: outFile << "4"; break;
			case 101: outFile << "5"; break;
			case 110: outFile << "6"; break;
			case 111: outFile << "7"; break;
			case 1000: outFile << "8"; break;
			case 1001: outFile << "9"; break;
			case 1010: outFile << "a"; break;
			case 1011: outFile << "b"; break;
			case 1100: outFile << "c"; break;
			case 1101: outFile << "d"; break;
			case 1110: outFile << "e"; break;
			case 1111: outFile << "f"; break;
		}
		if(i == word2.size()-4)
            outFile << endl;
        else if(i % 16 == 12)
			outFile << "_";
	}
}
