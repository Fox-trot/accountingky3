﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СписокВыбораСпособРасчета();
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура вызывается при нажатии кнопки "Редактировать формулу расчета". 
//
&НаКлиенте
Процедура КомандаРедактироватьФормулуРасчета(Команда)
	
	СтруктураПараметров = Новый Структура("ТекстФормулы, Ссылка", Объект.Формула, Объект.Ссылка);
	Оповещение = Новый ОписаниеОповещения("КомандаРедактироватьФормулуРасчетаЗавершение",ЭтаФорма);
	ОткрытьФорму("ПланВидовРасчета.ВидыНачислений.Форма.ФормаРедактированияФормулыРасчета", СтруктураПараметров,,,,,Оповещение);
	
КонецПроцедуры // КомандаРедактироватьФормулуРасчетаВыполнить()

&НаКлиенте
Процедура КомандаРедактироватьФормулуРасчетаЗавершение(ТекстФормулы,Параметры) Экспорт

	Если ТипЗнч(ТекстФормулы) = Тип("Строка") Тогда
		Объект.Формула = ТекстФормулы;
	КонецЕсли;

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода СпособРасчета.
//
&НаКлиенте
Процедура СпособРасчетаПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура РасчетОтОбратногоПриИзменении(Элемент)
	СписокВыбораСпособРасчета();
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.Наименование.ТолькоПросмотр = Объект.Предопределенный;
	
	Элементы.СтраницаБазовыеВидыРасчета.Видимость = Ложь;
	Элементы.СтраницаВытесняющиеВидыРасчета.Видимость = Ложь;
	Элементы.КоличествоЧасов.Видимость = Ложь;
	Элементы.Коэффициент1.Видимость = Ложь;
	Элементы.Коэффициент2.Видимость = Ложь;
	Элементы.Доля.Видимость = Ложь;
	Элементы.ПериодРасчетаСреднегоЗаработка.Видимость = Ложь;	
	Элементы.СтраницаПроизвольнаяФормула.Видимость = Ложь;
	
	Элементы.ОблагаетсяПН.Видимость = Истина;
	Элементы.ОблагаетсяСФ.Видимость = Истина;
	Элементы.ОблагаетсяПрофВзнос.Видимость = Истина;
	Элементы.ЗачетОтработанногоВремени.Видимость = Истина;
	Элементы.ЯвляетсяДоходомВНатуральнойФорме.Видимость = Истина;
	
	Если Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ПоМесячнойСтавкеПоДням
		Или Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ПоМесячнойСтавкеПоЧасам
		Или Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ПоДневнойСтавке
		Или Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ПоЧасовойСтавке Тогда 
		Элементы.СтраницаВытесняющиеВидыРасчета.Видимость = Истина;
	ИначеЕсли Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.РаботаСверхурочно Тогда 
		Элементы.КоличествоЧасов.Видимость = Истина;
		Элементы.Коэффициент1.Видимость = Истина;
		Элементы.Коэффициент2.Видимость = Истина;
	ИначеЕсли Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ВыходныеИПраздничные Тогда 
		Элементы.Коэффициент1.Видимость = Истина;
	ИначеЕсли Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ОплатаОтпуска
		Или Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ОплатаБольничного Тогда 		
		Элементы.СтраницаБазовыеВидыРасчета.Видимость = Истина;
		Элементы.ПериодРасчетаСреднегоЗаработка.Видимость = Истина;
	ИначеЕсли Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.Процентом Тогда 		
		Элементы.СтраницаБазовыеВидыРасчета.Видимость = Истина;
	ИначеЕсли Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ГодоваяПремия Тогда 
		Элементы.СтраницаБазовыеВидыРасчета.Видимость = Истина;
		Элементы.Доля.Видимость = Истина;
	ИначеЕсли Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.Неявка Тогда 
		Элементы.ОблагаетсяПН.Видимость = Ложь;
		Элементы.ОблагаетсяСФ.Видимость = Ложь;
		Элементы.ОблагаетсяПрофВзнос.Видимость = Ложь;
		Элементы.ЗачетОтработанногоВремени.Видимость = Ложь;
		Элементы.ЯвляетсяДоходомВНатуральнойФорме.Видимость = Ложь; 
	ИначеЕсли Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.ПроизвольнаяФормула Тогда 
		Элементы.СтраницаПроизвольнаяФормула.Видимость = Истина;
		
		Если СтрНайти(Объект.Формула, "ФактДней") > 0
			Или СтрНайти(Объект.Формула, "ФактЧасов") > 0 Тогда 
			
			Элементы.СтраницаВытесняющиеВидыРасчета.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;	
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация")));
	
КонецПроцедуры 

&НаСервере
Процедура СписокВыбораСпособРасчета()

	МассивСпособовРасчета = Новый Массив;
	
	МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоМесячнойСтавкеПоДням);	
	МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоДневнойСтавке);	
	МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ФиксированнойСуммой);	
	МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоМесячнойСтавкеПоЧасам);	
	МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПоЧасовойСтавке);	

	Если НЕ Объект.РасчетОтОбратного Тогда 
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.Процентом);	
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.РаботаСверхурочно);	
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ВыходныеИПраздничные);	
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ОплатаБольничного);	
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ОплатаОтпуска);	
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.Неявка);	
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ГодоваяПремия);	
		МассивСпособовРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ПроизвольнаяФормула);	
	КонецЕсли;	

	Элементы.СпособРасчета.СписокВыбора.Очистить();
	Элементы.СпособРасчета.СписокВыбора.ЗагрузитьЗначения(МассивСпособовРасчета);
КонецПроцедуры 

#КонецОбласти
