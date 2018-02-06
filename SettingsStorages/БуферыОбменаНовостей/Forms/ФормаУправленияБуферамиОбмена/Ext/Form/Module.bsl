﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ТипСписокЗначений = Тип("СписокЗначений");

	ЭтотОбъект.ПрограммноеЗакрытие = Ложь;

	Если Параметры.ТекущийПользователь.Пустая()
			ИЛИ (НЕ ПравоДоступа("СохранениеДанныхПользователя", Метаданные)) Тогда
		ЭтотОбъект.ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		ЭтотОбъект.ТекущийПользователь = Параметры.ТекущийПользователь;
	КонецЕсли;
	ЭтотОбъект.ТекущийПользователь_Имя = ОбработкаНовостейПовтИсп.ПолучитьИмяПользователяИБ(ЭтотОбъект.ТекущийПользователь);

	Если ПустаяСтрока(Параметры.КлючОбъекта) Тогда
		Отказ = Истина;
		Возврат;
	Иначе
		ЭтотОбъект.КлючОбъекта = Параметры.КлючОбъекта;
		ОбновитьСписокНастроекСервер();
	КонецЕсли;

	Если ТипЗнч(Параметры.ТекущийБуферОбмена) = ТипСписокЗначений Тогда
		ЭтотОбъект.ТекущийБуферОбмена.ЗагрузитьЗначения(Параметры.ТекущийБуферОбмена.ВыгрузитьЗначения());
	Иначе
		ЭтотОбъект.ТекущийБуферОбмена.Очистить();
	КонецЕсли;

	Если ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") 
			ИЛИ ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий")
			ИЛИ ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным")
			ИЛИ ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные")
			ИЛИ ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Документы.Новости.Действия")
			ИЛИ ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Справочники.Продукты.Родители")
			ИЛИ ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей")
			ИЛИ ВРег(ЭтотОбъект.КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда
		ХранилищаНастроек.БуферыОбменаНовостей.ПровестиВалидациюНастроек(ЭтотОбъект.ТекущийБуферОбмена, ЭтотОбъект.КлючОбъекта);
	КонецЕсли;

	ОбновитьИнформационныеСтроки();

	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Элементы.СписокКлючейНастроекКомандаВыгрузитьСписокБуферовОбмена.Видимость = Ложь;
		Элементы.СписокКлючейНастроекКомандаЗагрузитьСписокБуферовОбмена.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "БуферОбмена: изменился состав сохраненных" Тогда
		Если Источник.Свойство("КлючОбъекта")
				И Источник.КлючОбъекта = ЭтотОбъект.КлючОбъекта Тогда
			ОбновитьСписокНастроекСервер();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Введено наименование настройки (%1),
			|но она не записана.
			|
			|Записать?'"),
		ЭтотОбъект.КлючНастройки);

	Если ЗавершениеРаботы = Истина Тогда
		Отказ = Истина;
		ТекстПредупреждения = ТекстВопроса;
	Иначе
		// Если ввели имя в КлючНастройки, но не нажали Записать, то переспросить.
		Если ЭтотОбъект.ПрограммноеЗакрытие <> Истина Тогда
			Если ЭтотОбъект.ТекущийБуферОбмена.Количество() > 0 Тогда
				Если НЕ ПустаяСтрока(ЭтотОбъект.КлючНастройки) Тогда
					Если ЭтотОбъект.СписокКлючейНастроек.НайтиПоЗначению(ЭтотОбъект.КлючНастройки) = Неопределено Тогда
						// Ввели имя, но не нажали Сохранить.
						Отказ = Истина;
						СтандартнаяОбработка = Ложь;
						ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ЗаписатьНастройкуПередЗакрытием", ЭтотОбъект);
						СписокКнопок = Новый СписокЗначений;
						СписокКнопок.Добавить("ЗаписатьИЗакрыть", НСтр("ru='Записать и закрыть'"));
						СписокКнопок.Добавить("Закрыть", НСтр("ru='Закрыть без записи'"));
						СписокКнопок.Добавить("Отмена", НСтр("ru='Не закрывать'"));
						ПоказатьВопрос(ОписаниеОповещенияОЗакрытии, ТекстВопроса, СписокКнопок, 0, "ЗаписатьИЗакрыть", НСтр("ru='Текущее значение буфера обмена не сохранено'"));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_СписокКлючейНастроек

&НаКлиенте
Процедура СписокКлючейНастроекПриАктивизацииСтроки(Элемент)

	// Вставить имя в поле КлючНастройки.
	ТекущиеДанные = Элементы.СписокКлючейНастроек.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ЭтотОбъект.КлючНастройки = ТекущиеДанные.Значение;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписать(Команда)

	Если ПроверитьЗаполнение() Тогда
		КомандаЗаписатьНаСервере();
		Оповестить(
			"БуферОбмена: изменился состав сохраненных",
			,
			Новый Структура("КлючОбъекта, Ссылка",
				ЭтотОбъект.КлючОбъекта,
				Неопределено));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалить(Команда)

	ТекущиеДанные = Элементы.СписокКлючейНастроек.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		КомандаУдалитьНаСервере(ЭтотОбъект.КлючОбъекта, ТекущиеДанные.Значение, ЭтотОбъект.ТекущийПользователь_Имя);
		Оповестить(
			"БуферОбмена: изменился состав сохраненных",
			,
			Новый Структура("КлючОбъекта, Ссылка",
				ЭтотОбъект.КлючОбъекта,
				Неопределено));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузитьСписокБуферовОбмена(Команда)

	// Форма НЕ вызывается из ВебКлиента.
	// Кнопка скрывается в ПриСозданииНаСервере.

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок = НСтр("ru='Выберите файл, куда записать список буферов обмена'");
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Расширение = "xml";
	Диалог.Фильтр = "Файл xml (*.xml)|*.xml";
	Если Диалог.Выбрать() Тогда
		КомандаВыгрузитьСписокБуферовОбменаНаСервере(Диалог.ПолноеИмяФайла);
		ПоказатьОповещениеПользователя(
			НСтр("ru='Данные выгружены.'"),
			,
			,
			БиблиотекаКартинок.Записать);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьСписокБуферовОбмена(Команда)

	// Форма НЕ вызывается из ВебКлиента.
	// Кнопка скрывается в ПриСозданииНаСервере.

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru='Выберите файл с сохраненными ранее буферами обмена'");
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Расширение = "xml";
	Диалог.Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml'");
	Если Диалог.Выбрать() Тогда
		КомандаЗагрузитьСписокБуферовОбменаНаСервере(Диалог.ПолноеИмяФайла);
		ПоказатьОповещениеПользователя(
			НСтр("ru='Данные загружены.'"),
			,
			,
			БиблиотекаКартинок.ОткрытьФайл);
		Оповестить(
			"БуферОбмена: изменился состав сохраненных",
			,
			Новый Структура("КлючОбъекта, Ссылка",
				ЭтотОбъект.КлючОбъекта,
				Неопределено));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура КомандаЗаписатьНаСервере()

	ХранилищаНастроек.БуферыОбменаНовостей.Сохранить(
		ЭтотОбъект.КлючОбъекта,
		ЭтотОбъект.КлючНастройки,
		ЭтотОбъект.ТекущийБуферОбмена,
		,
		ЭтотОбъект.ТекущийПользователь_Имя);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура КомандаУдалитьНаСервере(лкКлючОбъекта, лкКлючНастройки, лкИмяПользователя)

	ХранилищаНастроек.БуферыОбменаНовостей.Удалить(
		лкКлючОбъекта,
		лкКлючНастройки,
		лкИмяПользователя);

КонецПроцедуры

&НаСервере
// Обновляет информационные надписи.
//
Процедура ОбновитьИнформационныеСтроки()

	ТипСписокЗначений = Тип("СписокЗначений");

	Если ЭтотОбъект.ТекущийБуферОбмена.Количество() <= 0 Тогда
		ЭтотОбъект.ТекущийБуферОбмена_Представление =
			НСтр("ru='Пустой буфер обмена.
				|Нельзя сохранить пустой буфер обмена.
				|Вначале скопируйте в него строки данных.'");
		Элементы.КомандаЗаписать.Доступность = Ложь;
	Иначе
		ЭтотОбъект.ТекущийБуферОбмена_Представление = "";
		// Сформировать строковое представление таблицы значений.
		Если ЭтотОбъект.КлючОбъекта = "Документы.Новости.КатегорииПростые" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.КатегорияНовостей)
						+ " " + СокрЛП(ТекущаяСтрока.Значение.УсловиеОтбора)
						+ " " + СокрЛП(ТекущаяСтрока.Значение.ЗначениеКатегорииНовостей)
						+ " (" + СокрЛП(ТекущаяСтрока.Значение.Автор) + ")"
					+ Символы.ПС;
			КонецЦикла;
		ИначеЕсли ЭтотОбъект.КлючОбъекта = "Документы.Новости.КатегорииИнтервалыВерсий" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.Продукт) + ", "
						+ СокрЛП(ТекущаяСтрока.Значение.ПредставлениеИнтервалаВерсий)
						+ " (" + СокрЛП(ТекущаяСтрока.Значение.Автор) + ")"
					+ Символы.ПС;
			КонецЦикла;
		ИначеЕсли ЭтотОбъект.КлючОбъекта = "Документы.Новости.ПривязкаКМетаданным" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.Метаданные) + ", "
						+ СокрЛП(ТекущаяСтрока.Значение.Форма) + ", "
						+ СокрЛП(ТекущаяСтрока.Значение.Событие) + ", "
						+ ПолучитьОписаниеВажности(ТекущаяСтрока.Значение.Важность)
					+ Символы.ПС;
			КонецЦикла;
		ИначеЕсли ЭтотОбъект.КлючОбъекта = "Документы.Новости.БинарныеДанные" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.УИН) + ", "
						+ СокрЛП(ТекущаяСтрока.Значение.Заголовок) + ", "
						+ СокрЛП(ТекущаяСтрока.Значение.ИнтернетСсылка) + ", "
						+ СокрЛП(ТекущаяСтрока.Значение.ДанныеРазмер) + " байт, "
					+ Символы.ПС;
			КонецЦикла;
		ИначеЕсли ЭтотОбъект.КлючОбъекта = "Документы.Новости.Действия" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.УИНДействия) + ", "
						+ СокрЛП(ТекущаяСтрока.Значение.Действие) + ", "
						+ ?(ТипЗнч(ТекущаяСтрока.Значение.ПараметрыДействий) = ТипСписокЗначений, "параметров: " + ТекущаяСтрока.Значение.ПараметрыДействий.Количество() + ", ", ", ")
					+ Символы.ПС;
			КонецЦикла;
		ИначеЕсли ЭтотОбъект.КлючОбъекта = "Справочники.Продукты.Родители" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.Продукт) + " "
						+ СокрЛП(ТекущаяСтрока.Значение.ВерсияПродукта) + ", соответствует "
						+ СокрЛП(ТекущаяСтрока.Значение.ПредставлениеИнтервалаВерсий)
					+ Символы.ПС;
			КонецЦикла;
		ИначеЕсли ЭтотОбъект.КлючОбъекта = "Справочники.Продукты.КаналыРаспространенияНовостей" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.КаналРаспространенияНовостей) + " для "
						+ СокрЛП(ТекущаяСтрока.Значение.ПредставлениеИнтервалаВерсий)
					+ Символы.ПС;
			КонецЦикла;
		ИначеЕсли ЭтотОбъект.КлючОбъекта = "Справочники.Пользователи.ПраваДоступаКТематическимПодборкам" Тогда
			Для каждого ТекущаяСтрока Из ЭтотОбъект.ТекущийБуферОбмена Цикл
				ЭтотОбъект.ТекущийБуферОбмена_Представление = 
					ЭтотОбъект.ТекущийБуферОбмена_Представление
					+ СокрЛП(ТекущаяСтрока.Значение.ТематическаяПодборка) + ":"
						+ ?(ТекущаяСтрока.Значение.Чтение,"Ч+","Ч-")
						+ ?(ТекущаяСтрока.Значение.Изменение,"Р+","Р-")
						+ ?(ТекущаяСтрока.Значение.Публикация,"П+","П-")
						+ ?(ТекущаяСтрока.Значение.ОтменаПубликации,"О+","О-")
					+ Символы.ПС;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
// Обновляет список сохраненных ранее настроек.
//
Процедура ОбновитьСписокНастроекСервер()

	// Загрузить все настройки.
	ЭтотОбъект.СписокКлючейНастроек.Очистить();
	лкСписокСохраненныхНастроек = ХранилищаНастроек.БуферыОбменаНовостей.ПолучитьСписок(ЭтотОбъект.КлючОбъекта, ЭтотОбъект.ТекущийПользователь_Имя);
	ЭтотОбъект.СписокКлючейНастроек.ЗагрузитьЗначения(лкСписокСохраненныхНастроек.ВыгрузитьЗначения());

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
// Возвращает "Обычная" для 0, "Очень важная" для 1 и "Важная" для 2.
//
// Параметры:
//  Важность - Число - 0, 1, 2 - важность.
//
// Возвращаемое значение:
//   Строка - строковое представление важности.
//
Функция ПолучитьОписаниеВажности(Важность)

	Если Важность = 1 Тогда
		Возврат НСтр("ru='Очень важная'");
	ИначеЕсли Важность = 2 Тогда
		Возврат НСтр("ru='Важная'");
	Иначе
		Возврат НСтр("ru='Обычная'");
	КонецЕсли;

КонецФункции

&НаСервере
Процедура КомандаВыгрузитьСписокБуферовОбменаНаСервере(ИмяФайла)

	ТипСтруктура      = Тип("Структура");
	ТипСписокЗначений = Тип("СписокЗначений");

	ЗаписьХМЛ = Новый ЗаписьXML();
	ЗаписьХМЛ.ОткрытьФайл(
		ИмяФайла,
		Новый ПараметрыЗаписиXML(
			"UTF-8",    // Кодировка
			,           // Версия
			Истина,     // Отступ
			Истина,     // ОтступАтрибутов
			Символы.Таб)); // СимволыОтступа

		ЗаписьХМЛ.ЗаписатьОбъявлениеXML();

		ЗаписьХМЛ.ЗаписатьКомментарий(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Выгрузка данных буферов обмена для %1, %2'"),
				ЭтотОбъект.КлючОбъекта,
				Формат(ТекущаяДатаСеанса(),"ДЛФ=DT")));

		ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Clipboards", "http://v8.1c.ru/news1c/wsAuxiliaryTypes"); // Самый верхний тег-обертка
			ЗаписьХМЛ.ЗаписатьСоответствиеПространстваИмен("n1c", "http://v8.1c.ru/news1c/wsAuxiliaryTypes");

			ЗаписьХМЛ.ЗаписатьНачалоЭлемента("ClipboardSet", "http://v8.1c.ru/news1c/wsAuxiliaryTypes"); // КлючОбъекта
			ЗаписьХМЛ.ЗаписатьАтрибут("id", ЭтотОбъект.КлючОбъекта);

			Для каждого ТекущийЭлементСпискаБуферОбмена Из ЭтотОбъект.СписокКлючейНастроек Цикл
				ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Clipboard", "http://v8.1c.ru/news1c/wsAuxiliaryTypes"); // КлючНастройки
					ЗаписьХМЛ.ЗаписатьАтрибут("id", ТекущийЭлементСпискаБуферОбмена.Значение);
					// Получить и записать значения.
					ЗначениеБуфераОбмена = ХранилищаНастроек.БуферыОбменаНовостей.Загрузить(ЭтотОбъект.КлючОбъекта, ТекущийЭлементСпискаБуферОбмена.Значение, , ЭтотОбъект.ТекущийПользователь_Имя);
					Если ТипЗнч(ЗначениеБуфераОбмена)= ТипСписокЗначений Тогда
						Для каждого ТекущееЗначениеСтрокиБуфераОбмена Из ЗначениеБуфераОбмена Цикл
							Если ТипЗнч(ТекущееЗначениеСтрокиБуфераОбмена.Значение) = ТипСтруктура Тогда
								ЗаписьХМЛ.ЗаписатьНачалоЭлемента("ClipboardRow", "http://v8.1c.ru/news1c/wsAuxiliaryTypes");
									СериализаторXDTO.ЗаписатьXML(ЗаписьХМЛ, ТекущееЗначениеСтрокиБуфераОбмена.Значение, НазначениеТипаXML.Явное, ФормаXML.Элемент);
								ЗаписьХМЛ.ЗаписатьКонецЭлемента();
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				ЗаписьХМЛ.ЗаписатьКонецЭлемента();
			КонецЦикла;

			ЗаписьХМЛ.ЗаписатьКонецЭлемента();
		ЗаписьХМЛ.ЗаписатьКонецЭлемента();

	ЗаписьХМЛ.Закрыть();

КонецПроцедуры

&НаСервере
Процедура КомандаЗагрузитьСписокБуферовОбменаНаСервере(ИмяФайла)

	ТипСтруктура = Тип("Структура");

	ЧтениеХМЛ = Новый ЧтениеXML;
	ЧтениеХМЛ.ОткрытьФайл(ИмяФайла);

	ОбъектХДТО = ФабрикаXDTO.ПрочитатьXML(ЧтениеХМЛ, ФабрикаXDTO.Тип("http://v8.1c.ru/news1c/wsAuxiliaryTypes", "Clipboards"));
	Если ТипЗнч(ОбъектХДТО) = Тип("ОбъектXDTO") Тогда
		Если (ОбъектХДТО.Тип().URIПространстваИмен = "http://v8.1c.ru/news1c/wsAuxiliaryTypes")
				И (ВРег(СокрЛП(ОбъектХДТО.Тип().Имя)) = ВРег(СокрЛП("Clipboards"))) Тогда
			Свойство_ClipboardSet = ОбъектХДТО.Свойства().Получить("ClipboardSet");
			Если (ТипЗнч(Свойство_ClipboardSet) = Тип("СвойствоXDTO"))
					И (Свойство_ClipboardSet.ВерхняяГраница = -1) Тогда
				КлючиОбъектов = ОбъектХДТО.ПолучитьСписок(Свойство_ClipboardSet);
				Для каждого ТекущийКлючОбъекта Из КлючиОбъектов Цикл
					Если ВРег(СокрЛП(ТекущийКлючОбъекта.id)) = ВРег(СокрЛП(ЭтотОбъект.КлючОбъекта)) Тогда // Читать настройки только для текущего КлючаОбъекта
						Если ТипЗнч(ТекущийКлючОбъекта) = Тип("ОбъектXDTO") Тогда
							Свойство_Clipboard = ТекущийКлючОбъекта.Свойства().Получить("Clipboard");
							Если (ТипЗнч(Свойство_Clipboard) = Тип("СвойствоXDTO"))
									И (Свойство_Clipboard.ВерхняяГраница = -1) Тогда
								КлючиНастроек = ТекущийКлючОбъекта.ПолучитьСписок(Свойство_Clipboard);
								Для каждого ТекущийКлючНастроек Из КлючиНастроек Цикл
									ЗначениеБуфераОбмена = Новый СписокЗначений;
									Свойство_ClipboardRow = ТекущийКлючНастроек.Свойства().Получить("ClipboardRow");
									Если (ТипЗнч(Свойство_ClipboardRow) = Тип("СвойствоXDTO"))
											И (Свойство_ClipboardRow.ВерхняяГраница = -1) Тогда
										СтрокиБуфераОбмена = ТекущийКлючНастроек.ПолучитьСписок(Свойство_ClipboardRow);
										Для каждого ТекущаяСтрокаБуфераОбмена Из СтрокиБуфераОбмена Цикл
											Свойство_Structure = ТекущаяСтрокаБуфераОбмена.Свойства().Получить("Structure");
											Если (ТипЗнч(Свойство_Structure) = Тип("СвойствоXDTO")) Тогда
												ЗначениеСтрокиБуфераОбменаХДТО = ТекущаяСтрокаБуфераОбмена.Получить(Свойство_Structure);
												Если ТипЗнч(ЗначениеСтрокиБуфераОбменаХДТО) = Тип("ОбъектXDTO") Тогда
													ЗначениеСтрокиБуфераОбмена = СериализаторXDTO.ПрочитатьXDTO(ЗначениеСтрокиБуфераОбменаХДТО);
													Если ТипЗнч(ЗначениеСтрокиБуфераОбмена) = ТипСтруктура Тогда
														ЗначениеБуфераОбмена.Добавить(ЗначениеСтрокиБуфераОбмена);
													КонецЕсли;
												КонецЕсли;
											КонецЕсли;
										КонецЦикла;
									КонецЕсли;
									// Записать буфер обмена в хранилище настроек.
									ХранилищаНастроек.БуферыОбменаНовостей.Сохранить(ТекущийКлючОбъекта.id, ТекущийКлючНастроек.id, ЗначениеБуфераОбмена, , ЭтотОбъект.ТекущийПользователь_Имя);
								КонецЦикла;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ОбновитьСписокНастроекСервер();

КонецПроцедуры

&НаКлиенте
// Обработчик перед закрытием, если значение буфера обмена не сохранено.
//
// Параметры:
//  РезультатВопроса - Строка - одно из значений: "ЗаписатьИЗакрыть", "Закрыть", "Отмена";
//  ДополнительныеПараметры - Произвольный.
//
Процедура ЗаписатьНастройкуПередЗакрытием(РезультатВопроса, ДополнительныеПараметры = Неопределено) Экспорт

	Если РезультатВопроса = "ЗаписатьИЗакрыть" Тогда
		Если ПроверитьЗаполнение() Тогда
			КомандаЗаписатьНаСервере();
			Оповестить(
				"БуферОбмена: изменился состав сохраненных",
				,
				Новый Структура("КлючОбъекта, Ссылка",
					ЭтотОбъект.КлючОбъекта,
					Неопределено));
			ЭтотОбъект.ПрограммноеЗакрытие = Истина;
			ЭтотОбъект.Закрыть();
		КонецЕсли;
	ИначеЕсли РезультатВопроса = "Закрыть" Тогда
		ЭтотОбъект.ПрограммноеЗакрытие = Истина;
		ЭтотОбъект.Закрыть();
	ИначеЕсли РезультатВопроса = "Отмена" Тогда
		ЭтотОбъект.ПрограммноеЗакрытие = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

