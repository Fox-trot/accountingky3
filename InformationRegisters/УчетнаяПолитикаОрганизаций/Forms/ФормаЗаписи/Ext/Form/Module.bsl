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
		Запись.СпособОценкиТМЗ = Перечисления.СпособыОценки.ПоСредней;
	КонецЕсли;
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНДС.
//
&НаКлиенте
Процедура ПлательщикНДСПриИзменении(Элемент)
	
	Если Запись.ПлательщикНДС Тогда 
		Запись.ОтчетПоНСПВСекциюБ = Ложь;
	КонецЕсли;
	Запись.ПлательщикЕН = Ложь; 
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНСП.
//
&НаКлиенте
Процедура ПлательщикНСППриИзменении(Элемент)
	
	Если Не Запись.ПлательщикНСП Тогда 
		 Запись.ОтчетПоНСПВСекциюБ = Ложь;
	КонецЕсли;
	Запись.ПлательщикЕН = Ложь;
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНП.
//
&НаКлиенте
Процедура ПлательщикНППриИзменении(Элемент)
	Запись.ПлательщикЕН = Ложь;
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикНИ.
//
&НаКлиенте
Процедура ПлательщикНИПриИзменении(Элемент)
	Запись.ПлательщикЕН = Ложь;
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПлательщикЕН.
//
&НаКлиенте
Процедура ПлательщикЕНПриИзменении(Элемент)
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
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Запись.ПлательщикЕН = Истина Тогда
		Запись.ПлательщикНДС 	= Ложь;
		Запись.ПлательщикНСП 	= Ложь;
		Запись.ПлательщикНП 	= Ложь;
		Запись.ПлательщикНИ 	= Ложь;
	Иначе 
		Запись.ПлательщикЕН 	= Ложь;
	КонецЕсли;
	
	Элементы.ОтчетПоНСПВСекциюБ.Видимость 									= Запись.ПлательщикНСП И Не Запись.ПлательщикНДС;
	Элементы.УчетНДСНаАвансы.Видимость 										= Запись.ПлательщикНДС;
	Элементы.УказыватьПризнакЗачетаНДСПриПоступлении.Видимость 				= Запись.ПлательщикНДС;
	Элементы.СтавкаНСПДляРасчетаНДСНаАвансы.Видимость						= Запись.ПлательщикНДС;
	Элементы.ГруппаНП.Видимость 											= Запись.ПлательщикНП;
	Элементы.ПороговыйПроцентОсвобожденныхПоставок.Видимость 				= Запись.ПлательщикНДС;
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

// Процедура устанавливает функциональные опции формы документа.
//
&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма, Запись.Организация, Запись.Период);
КонецПроцедуры

#КонецОбласти        
