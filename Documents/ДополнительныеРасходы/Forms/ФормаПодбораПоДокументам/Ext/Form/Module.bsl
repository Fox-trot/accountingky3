﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("УникальныйИдентификаторФормыВладельца", УникальныйИдентификаторФормыВладельца);
	Параметры.Свойство("СпособЗаполнения", СпособЗаполнения);
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("ДатаОтбора", Параметры.ДатаОтбора);
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДокументовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Значение.Количество() > 1 И СпособЗаполнения = "Добавить" Тогда		
		АдресДокументовВХранилище = ЗаписатьПодборВХранилище(Значение);
	Иначе
		АдресДокументовВХранилище = ЗаписатьПодборВХранилище(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресДокументовВХранилище", АдресДокументовВХранилище);
	
	Если СпособЗаполнения = "Заполнить" Тогда 
		Оповестить("ПодборПоДокументамПроизведен_Заполнить", ПараметрыПодбора, УникальныйИдентификаторФормыВладельца);
	Иначе 
		Оповестить("ПодборПоДокументамПроизведен_Добавить", ПараметрыПодбора, УникальныйИдентификаторФормыВладельца);		
	КонецЕсли;
	
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Функция помещает результаты подбора в хранилище
//
Функция ЗаписатьПодборВХранилище(Значение) 
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		Схема = Элементы.СписокДокументов.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
		Настройки = Элементы.СписокДокументов.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
		МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;	
		ТаблицаПоступлений = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
		МассивДокумент = Новый Массив();
		
		Для Каждого СтрокаМассива Из Значение Цикл
			МассивДокумент.Добавить(ТаблицаПоступлений[СтрокаМассива - 1].Ссылка);	
		КонецЦикла;	
		
		Возврат ПоместитьВоВременноеХранилище(МассивДокумент, УникальныйИдентификаторФормыВладельца);
		
	Иначе
		Возврат ПоместитьВоВременноеХранилище(Значение, УникальныйИдентификаторФормыВладельца);
	КонецЕсли;	
	
КонецФункции //ЗаписатьПодборВХранилище() 

#КонецОбласти