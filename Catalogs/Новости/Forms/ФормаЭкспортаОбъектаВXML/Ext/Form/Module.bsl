﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.ПредставлениеXML = Параметры.ПредставлениеXML;
	ЭтотОбъект.КартинкаФайлЗаписан = БиблиотекаКартинок.Записать;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	#Если ВебКлиент Тогда

		Элементы.ГруппаИмяФайла.Видимость = Ложь;

	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписать(Команда)

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок = НСтр("ru='Выберите файл, куда записать содержимое XML'");
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Расширение = "xml";
	Диалог.Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml'");

	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещенияПослеВыбора = Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтотОбъект, ДополнительныеПараметры);

	Диалог.Показать(ОписаниеОповещенияПослеВыбора);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	ТипМассив = Тип("Массив");

	Если (ТипЗнч(ВыбранныеФайлы) = ТипМассив)
			И (ВыбранныеФайлы.Количество() > 0) Тогда

		ИмяФайла = ВыбранныеФайлы[0];

		Если НЕ ПустаяСтрока(ИмяФайла) Тогда

			Если ПустаяСтрока(ЭтотОбъект.ПредставлениеXML) Тогда

				ТекстСообщения = НСтр("ru='Текст пустой. Нечего сохранять.'");
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Поле  = "ПредставлениеXML"; // Идентификатор.
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();

			Иначе

				ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, "UTF-8", Символы.ПС, Ложь, Символы.ПС);
					ЗаписьТекста.Записать(ЭтотОбъект.ПредставлениеXML);
				ЗаписьТекста.Закрыть();

				ПоказатьОповещениеПользователя(
					НСтр("ru='Файл записан.'"),
					ОбработкаНовостейКлиент.ПолучитьДействиеОткрытияФайла(ИмяФайла, "КакТекстВ1С"),
					ИмяФайла,
					ЭтотОбъект.КартинкаФайлЗаписан);

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
