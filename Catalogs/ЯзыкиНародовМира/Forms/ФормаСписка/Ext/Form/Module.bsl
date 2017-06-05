﻿#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
	
&НаКлиенте
Процедура КомандаПодборИзКлассификатора(Команда)
	
	ПодобратьИзКлассификатора();
	ОбновитьОтображениеДанных();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий
	//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПодобратьИзКлассификатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьИзКлассификатора()
	ОбщегоНазначенияБПКлиент.ОткрытьФормуПодбораИзКлассификатора(
		"ЯзыкиНародовМира",	"Справочник.ЯзыкиНародовМира.КлассификаторЯзыковНародовМира", НСтр("ru = 'Языки народов мира'"), ЭтаФорма);
КонецПроцедуры

#КонецОбласти
