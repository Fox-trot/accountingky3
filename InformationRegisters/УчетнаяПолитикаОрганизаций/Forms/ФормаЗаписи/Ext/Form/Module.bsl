﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Это старая запись.
	Если ЗначениеЗаполнено(Параметры.Ключ.Организация)
		Или ЗначениеЗаполнено(Параметры.Ключ.Период) Тогда 
		ТолькоПросмотр = Истина;
	Иначе 
		//Запись.СпособОценкиТМЗ = Перечисления.СпособыОценки.ПоСредней;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();	

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	// Добавление признака Модифицированность для обновления интерфейса после записи.
	ПараметрыЗаписи.Вставить("Модифицированность", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ПараметрыЗаписи.Модифицированность Тогда 
		ОбновитьИнтерфейс();	
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНДС.
//
&НаКлиенте
Процедура ПлательщикНДСПриИзменении(Элемент)
	
	Если НЕ Запись.ПлательщикНДС Тогда
		Запись.УчетНДСНаАвансы = Ложь;
		Запись.УказыватьПризнакЗачетаНДСПриПоступлении = Ложь;
		Запись.НеУчитыватьЗакупкиБезНДС = Ложь;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНСП.
//
&НаКлиенте
Процедура ПлательщикНСППриИзменении(Элемент)
	
	Если Запись.ПлательщикНСП Тогда
		Запись.ПлательщикЕН = Ложь;
	Иначе 
		Запись.СтавкаНСПРеализацииТовары = ПредопределенноеЗначение("Справочник.СтавкиНСП.ПустаяСсылка");
		Запись.СтавкаНСПРеализацииУслуги = ПредопределенноеЗначение("Справочник.СтавкиНСП.ПустаяСсылка");
		Запись.СтавкаНСПДляРасчетаНДСНаАвансы = ПредопределенноеЗначение("Справочник.СтавкиНСП.ПустаяСсылка");
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНП.
//
&НаКлиенте
Процедура ПлательщикНППриИзменении(Элемент)
	Если Запись.ПлательщикНП Тогда
		Запись.ПлательщикЕН = Ложь;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНИ.
//
&НаКлиенте
Процедура ПлательщикНИПриИзменении(Элемент)
	Если Запись.ПлательщикНИ Тогда
		Запись.ПлательщикЕН = Ложь;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикЕН.
//
&НаКлиенте
Процедура ПлательщикЕНПриИзменении(Элемент)
	
	// Установка значений по умолчанию
	Если Запись.ПлательщикЕН Тогда
		Запись.ПлательщикНСП = Ложь;
		Запись.ПлательщикНП = Ложь;
		Запись.ПлательщикНИ = Ложь;
		
		Запись.СтавкаЕННаличнаяФорма1 = 4;
		Запись.СтавкаЕННаличнаяФорма2 = 2;
		Запись.СтавкаЕНБезНаличнаяФорма1 = 6;
		Запись.СтавкаЕНБезНаличнаяФорма2 = 3;
	Иначе 
		Запись.СтавкаЕННаличнаяФорма1 = 0;
		Запись.СтавкаЕННаличнаяФорма2 = 0;
		Запись.СтавкаЕНБезНаличнаяФорма1 = 0;
		Запись.СтавкаЕНБезНаличнаяФорма2 = 0;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	Элементы.ФормаВключитьВозможностьРедактирования.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.УчетНДСНаАвансы.Видимость = Запись.ПлательщикНДС;
	Элементы.УказыватьПризнакЗачетаНДСПриПоступлении.Видимость = Запись.ПлательщикНДС;
	Элементы.СтавкаНСПДляРасчетаНДСНаАвансы.Видимость = Запись.ПлательщикНДС;
	Элементы.НеУчитыватьЗакупкиБезНДС.Видимость = Запись.ПлательщикНДС;
	
	Элементы.СтавкаНалогаНаПрибыль.Видимость = Запись.ПлательщикНП;
	Элементы.ПроцентНП.Видимость = Запись.ПлательщикНП;
	
	Элементы.ПороговыйПроцентОсвобожденныхПоставок.Видимость = Запись.ПлательщикНДС;
	Элементы.ПроцентОП.Видимость = Запись.ПлательщикНДС;
	
	Элементы.Контракт.Видимость = Запись.ПлательщикНДС;
	
	Элементы.СтавкаНСПДляРасчетаНДСНаАвансы.Видимость = Запись.ПлательщикНСП;
	Элементы.СтавкаНСПРеализацииТовары.Видимость = Запись.ПлательщикНСП;
	Элементы.СтавкаНСПРеализацииУслуги.Видимость = Запись.ПлательщикНСП;
	
	// Единый налог.
	Элементы.СтавкаЕННаличнаяФорма1.Видимость = Запись.ПлательщикЕН;
	Элементы.СтавкаЕННаличнаяФорма2.Видимость = Запись.ПлательщикЕН;
	Элементы.СтавкаЕНБезНаличнаяФорма1.Видимость = Запись.ПлательщикЕН;
	Элементы.СтавкаЕНБезНаличнаяФорма2.Видимость = Запись.ПлательщикЕН;
	
КонецПроцедуры 

#КонецОбласти        
