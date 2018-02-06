﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Не должно быть повторений доступных категорий.
	ТаблицаПроверки = ДоступныеКатегорииНовостей.Выгрузить(, "КатегорияНовостей");
	ТаблицаПроверки.Колонки.Добавить("КоличествоСтрок");
	ТаблицаПроверки.ЗаполнитьЗначения(1, "КоличествоСтрок");
	ТаблицаПроверки.Свернуть("КатегорияНовостей", "КоличествоСтрок");
	Для каждого ТекущаяСтрока Из ТаблицаПроверки Цикл
		Если ТекущаяСтрока.КоличествоСтрок > 1 Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ДоступныеКатегорииНовостей";
			Сообщение.ПутьКДанным = "Объект";
			Сообщение.Текст = НСтр("ru='Категория [%КатегорияНовостей%] повторяется несколько раз.
				|Каждую категорию разрешено вводить только один раз.'");
			Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%КатегорияНовостей%", ТекущаяСтрока.КатегорияНовостей);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;

	Если ВРег(ЭтотОбъект.Протокол) = ВРег("file") Тогда
		// Удалить из проверяемых реквизитов "Сайт".
		НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Сайт");
		Если НайденнаяСтрока <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
		КонецЕсли;
	КонецЕсли;

	Если ЭтотОбъект.ЗагруженоССервера = Ложь Тогда
		Если ЭтотОбъект.ЛокальнаяЛентаНовостей = Истина Тогда
			// Удалить из проверяемых реквизитов все, связанное с обновлением:
			//  "Сайт", "Протокол", "ИмяФайла", "ВариантЛогинаПароля", "Логин", "Пароль".
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Сайт");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Протокол");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("ИмяФайла");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("ВариантЛогинаПароля");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Логин");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Пароль");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	// Возможные значения: http, https и file.
	Если ВРег(ЭтотОбъект.Протокол) = ВРег("https") Тогда
		ЭтотОбъект.Протокол = "https";
	ИначеЕсли ВРег(ЭтотОбъект.Протокол) = ВРег("http") Тогда
		ЭтотОбъект.Протокол = "http";
	ИначеЕсли ВРег(ЭтотОбъект.Протокол) = ВРег("file") Тогда
		ЭтотОбъект.Протокол = "file";
	Иначе
		ЭтотОбъект.Протокол = "http";
	КонецЕсли;

	// Для локально-обновляемой ленты новостей установить протокол "file",
	//  чтобы корректно отрабатывала Обработки.УправлениеНовостями.ЗагрузитьФайлыНовостейССервера(ЛентыНовостей).
	Если ЭтотОбъект.ЛокальнаяЛентаНовостей = Истина Тогда
		ЭтотОбъект.Протокол = "file";
	КонецЕсли;

	Если ВРег(ЭтотОбъект.Протокол) = ВРег("file") Тогда
		ЭтотОбъект.Сайт   = "";
		ЭтотОбъект.ВариантЛогинаПароля = Перечисления.ВариантЛогинаПароляДляЛентыНовостей.БезЛогинаПароля;
		ЭтотОбъект.Логин  = "";
		ЭтотОбъект.Пароль = "";
	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтотОбъект.ЗагруженоССервера = Истина Тогда
		// Лента новостей, загруженная с сервера, не может быть локально-обновляемой
		//  (т.е. не загружать данные из файла, а создавать в справочнике напрямую).
		ЭтотОбъект.ЛокальнаяЛентаНовостей = Ложь;
		// Нельзя пометить на удаление ленту новостей, загруженную с сервера
		//  за исключением программного удаления (если ленту отключили в новостном центре).
		Если (ЭтотОбъект.ПометкаУдаления = Истина)
				И (Ссылка.ПометкаУдаления = Ложь) Тогда
			Если (ЭтотОбъект.ДополнительныеСвойства.Свойство("УдалениеЛентыНовостейЗагруженнойССервера") = Истина)
					И (ЭтотОбъект.ДополнительныеСвойства.УдалениеЛентыНовостейЗагруженнойССервера = Истина) Тогда
				// Все нормально, лента удаляется программно - вероятно, ее отключили в новостном центре.
			Иначе
				ТекстСообщения = НСтр("ru='Нельзя помечать на удаление ленты новостей, загруженные автоматически с сервера новостей.'");
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = ТекстСообщения;
				Сообщение.УстановитьДанные(Ссылка);
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// В модуле объекта не оптимизируются и не пересчитываются отборы по новостям.
	// Если происходит загрузка лент новостей (при загрузке классификаторов), то лучше пересчитать отборы один раз.
	// Если происходит редактирование элемента справочника, то отборы будут пересчитаны в форме элемента.

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли