﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.ЗакрыватьПриВыборе            = Истина;
	ЭтотОбъект.ЗакрыватьПриЗакрытииВладельца = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗагрузить(Команда)

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru='Выберите файл, откуда взять содержимое новости в формате XML'");
	Диалог.МножественныйВыбор = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.Расширение = "xml";
	Диалог.Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml'");
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	Иначе
		Возврат;
	КонецЕсли;

	Если НЕ ПустаяСтрока(ИмяФайла) Тогда
		ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, "UTF-8", Символы.ПС, Символы.ПС, Ложь);
			ЭтотОбъект.ПредставлениеXML = ЧтениеТекста.Прочитать();
		ЧтениеТекста .Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаИмпортировать(Команда)

	Если ПустаяСтрока(ЭтотОбъект.ПредставлениеXML) Тогда
		ОповеститьОВыборе(Ложь);
	Иначе
		ОповеститьОВыборе(ЭтотОбъект.ПредставлениеXML);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

