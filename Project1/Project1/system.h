#pragma once
#include "function.h"
using namespace std;
class System
{
public:
	int size;
	double t = 0;
	vector<double*> solutions;
	vector<double(*)(double *, double)> functions;
	void runge_cutte(double tmax, double h, FILE * fo);
	System(int size);
	~System();

private:
};

void System::runge_cutte(double tmax, double h, FILE * fo)
{
	int counter = 1;
	double k1, k2, k3, k4;
	double *tmp_solution;
	t = t + h;
	for (t; abs(t - tmax) <= DBL_EPSILON; t = t + h)
	{
		for (int i = 0; i < size; i++)
		{
			k1 = h*functions[i](solutions[counter - 1], t);
			tmp_solution = vector_plus_value(solutions[counter - 1], k1 / 2, size);
			k2 = h*functions[i](tmp_solution, t + h / 2);
			delete[] tmp_solution;
			tmp_solution = vector_plus_value(solutions[counter - 1], k2 / 2, size);
			k3 = h*functions[i](tmp_solution, t + h / 2);
			delete[] tmp_solution;
			tmp_solution = vector_plus_value(solutions[counter - 1], k3, size);
			k4 = h*functions[i](tmp_solution, t+h);
			delete[] tmp_solution;
			solutions[counter][i] = solutions[counter - 1][i] + 1 / 6 * (k1 + 2 * k2 + 2*k3 + k4);
		}
		counter++;
	}
}

System::System(int size)
{
	functions.push_back(f1);
	functions.push_back(f2);
	functions.push_back(f3);
	double * startsolutions = new double(size);
	solutions.push_back(startsolutions);
	solutions[0][0] = 0;
	solutions[0][1] = 0;
	solutions[0][2] = 0;
}

System::~System()
{
}