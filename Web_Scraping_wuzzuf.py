import requests
from bs4 import BeautifulSoup
import csv
from itertools import zip_longest

job_title = []
company_name = []
location_name = []
skills = []
links = []
responsibilities = []
salary = []

# use requests to fetch the url
result = requests.get('https://wuzzuf.net/search/jobs/?q=python&a=hpb')

# save page content/markup
src = result.content

# create soup object to parse content
soup = BeautifulSoup(src, 'lxml')

# find the elements containing info we need
job_titles = soup.find_all('h2', {'class':'css-m604qf'})
company_names = soup.find_all('a', {'class':'css-17s97q8'})
location = soup.find_all('span', {'class':'css-5wys0k'})
job_skills = soup.find_all('div', {'class':'css-y4udm8'})


# loop over returned lists to extract needed info into other lists
for i in range(len(job_titles)):
    job_title.append(job_titles[i].text)
    links.append(job_titles[i].find('a').attrs['href'])
    company_name.append(company_names[i].text)
    location_name.append(location[i].text)
    skills.append(job_skills[i].text)

for link in links:
    result = requests.get(link)
    src = result.content
    soup = BeautifulSoup(src, 'lxml')
    salaries = soup.find_all('span',class_="css-4xky9y")
    salary.append(salaries)
    requirement = soup.find('div', class_="css-1t5f0fr")
    respon_text = ''
    for li in requirement.find_All('li'):
        respon_text += li.text + '| '
    responsibilities.append(respon_text)

# create cvs file and fill it with values
file_list = [job_title, company_name, location_name, skills, links, salary, responsibilities]
exported = zip_longest(*file_list)
with open('C:\\Users\\abn x 6alb\\Desktop\\web_scripting_job.csv', 'w') as myfile:
    wr = csv.writer(myfile)
    wr.writerow(['Job Title', 'Company name', 'Location', 'Skills', 'links', 'salary', 'responsibilities'])
    wr.writerows(exported)
