#pragma once
#include <math.h>
#include <vector>
using namespace std;
double * vector_plus_value(double * vec, double value, int size)
{
	double* tmp = new double[size];
	for (int i = 0; i < size; i++)
	{
		tmp[i] = vec[i] + value;
	}
	return tmp;
};
double f1(double* y, double t)
{
	return 5;
}

double f2(double* y, double t)
{
	return 5;
}

double f3(double* y, double t)
{
	return 5;
}