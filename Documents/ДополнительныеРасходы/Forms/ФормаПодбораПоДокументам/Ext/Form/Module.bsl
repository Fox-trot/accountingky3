﻿#Область ОбработчикиСобытийФормы

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
	
	Параметры.Свойство("УникальныйИдентификаторФормыВладельца", УникальныйИдентификаторФормыВладельца);
	Параметры.Свойство("СпособЗаполнения", СпособЗаполнения);
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("ДатаОтбора", Параметры.ДатаОтбора);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДокументовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	АдресДокументовВХранилище = ЗаписатьПодборВХранилище(Элемент.ТекущиеДанные.Ссылка);
	
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
	
	Возврат ПоместитьВоВременноеХранилище(Значение, УникальныйИдентификаторФормыВладельца);
	
КонецФункции //ЗаписатьПодборВХранилище() 

#КонецОбласти