﻿
&НаКлиенте
Перем ЗакрытьБезусловно;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РегламентныеЗаданияСервер.РаботаСВнешнимиРесурсамиЗаблокирована() Тогда
		ВызватьИсключение НСтр("ru = 'Работа со всеми внешними ресурсами (синхронизация данных, отправка почты и т.п.) заблокирована.'");
	КонецЕсли;
	
	МиграцияПриложенийПереопределяемый.ПриОпределенииСервисов(Элементы.Сервис.СписокВыбора);
	Элементы.Сервис.СписокВыбора.Добавить("Другой", НСтр("ru = 'Другой сервис'"));
	Сервис = Элементы.Сервис.СписокВыбора[0].Значение;
	АдресСервиса = ?(Сервис = "Другой", "", Сервис);
	Элементы.АдресСервиса.ТолькоПросмотр = Сервис <> "Другой";
	Элементы.Сервис.Видимость = Элементы.Сервис.СписокВыбора.Количество() > 1;
	
	Логин = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
	Если Состояние <> Перечисления.СостоянияМиграцииПриложения.Выполняется Тогда
		
		Элементы.ПраваПользователейПраво.СписокВыбора.Добавить(МиграцияПриложенийКлиентСервер.ПравоЗапуск());
		Элементы.ПраваПользователейПраво.СписокВыбора.Добавить(МиграцияПриложенийКлиентСервер.ПравоЗапускИАдминистрирование());
		
		Наименование = СтрШаблон(НСтр("ru = '%1 (Миграция приложения)'"), Метаданные.Синоним);
		
		СостояниеРегистрацииВСервисе = Элементы.СостояниеРегистрацииВСервисе.СписокВыбора[0].Значение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(АдресСервиса) Тогда
		Сервис = ?(Элементы.Сервис.СписокВыбора.НайтиПоЗначению(АдресСервиса) = Неопределено, "Другой", АдресСервиса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриОткрытииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Или ЗначениеЗаполнено(ДатаНачала) Или ЗакрытьБезусловно = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемОповещение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Закрыть помощник?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьПользователяСервиса(Команда)
	
	ПараметрыДоступа = Новый Структура;
	ПараметрыДоступа.Вставить("Логин", Логин);
	ПараметрыДоступа.Вставить("Пароль", Пароль);
	ПараметрыДоступа.Вставить("КодАбонента", КодАбонента);
	ПараметрыДоступа.Вставить("АдресПрограммногоИнтерфейса", АдресПрограммногоИнтерфейса);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыДоступа", ПараметрыДоступа);
	ОткрытьФорму("Обработка.МиграцияПриложения.Форма.ДобавлениеПользователяСервиса", ПараметрыФормы, Элементы.ПраваПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаАдресСервиса Тогда
		НоваяСтраница = СтраницаАдресСервисаДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаИдентификационныеДанные Тогда
		НоваяСтраница = СтраницаИдентификационныеДанныеДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПодтверждениеРегистрации Тогда
		НоваяСтраница = СтраницаПодтверждениеРегистрацииДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыборАбонента Тогда
		НоваяСтраница = СтраницаВыборАбонентаДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПраваПользователей Тогда
		НоваяСтраница = СтраницаПраваПользователейДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСозданиеПриложение Тогда
		НоваяСтраница = СтраницаСозданиеПриложениеДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание Тогда
		НоваяСтраница = СтраницаОжиданиеДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		НоваяСтраница = СтраницаРезультатДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка Тогда
		НоваяСтраница = СтраницаОшибкаДалее();
	КонецЕсли;
	
	Если НоваяСтраница <> Неопределено Тогда
		ОткрытиеСтраницы(НоваяСтраница);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание Тогда
	
		ОтменитьПереход();
		ОтключитьОбработчикОжидания("ОбновлениеСтатусаПерехода");
		ПараметрыПриложения.Удалить("ТехнологияСервиса.МиграцияПриложений.ФормаПереходВСервис");
		
		ОткрытиеСтраницы(Элементы.СтраницаРезультат);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Страница = Элементы[СтекСтраниц[СтекСтраниц.Количество() - 2].Значение];
	Если Страница = Элементы.СтраницаПодтверждениеРегистрации Тогда
		Страница = Элементы[СтекСтраниц[СтекСтраниц.Количество() - 3].Значение];
	КонецЕсли;
	
	ОткрытиеСтраницы(Страница);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура СервисПриИзменении(Элемент)
	
	АдресСервиса = ?(Сервис = "Другой", "", Сервис);
	Элементы.АдресСервиса.ТолькоПросмотр = Сервис <> "Другой";
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеРегистрацииВСервисеПриИзменении(Элемент)
	
	Элементы.СтраницаИдентификационныеДанныеСтраницы.ТекущаяСтраница = 
		?(СостояниеРегистрацииВСервисе = "Зарегистрирован", 
			Элементы.СтраницаЗарегистрированныйПользователь, 
			Элементы.СтраницаРегистрация);
			
	Логин = Неопределено;
	Пароль = Неопределено;
	ПодтверждениеПароля = Неопределено;
	РегистрацияНаименование = Неопределено;
	РегистрацияТелефон = Неопределено;
	РегистрацияЭлектроннаяПочта = Неопределено;
			
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРегистрацияНажатие(Элемент)
	
	ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(АдресРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВосстановлениеНажатие(Элемент)
	
	ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(АдресВосстановления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваПользователейОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ПравоПользователя = ПраваПользователей.Добавить();
	ПравоПользователя.Логин = НовыйОбъект.Логин;
	ПравоПользователя.Наименование = НовыйОбъект.Наименование;
	ПравоПользователя.ЭлектроннаяПочта = НовыйОбъект.ЭлектроннаяПочта;
	ПравоПользователя.Роль = НовыйОбъект.Роль;
	
	// Пользователь создан чтобы предоставить ему доступ к приложению.
	Если ПравоПользователя.Роль = МиграцияПриложенийКлиентСервер.РольВладелец() 
		Или ПравоПользователя.Роль = МиграцияПриложенийКлиентСервер.РольАдминистратор() Тогда
		ПравоПользователя.Право = МиграцияПриложенийКлиентСервер.ПравоЗапускИАдминистрирование();
	Иначе
		ПравоПользователя.Право = МиграцияПриложенийКлиентСервер.ПравоЗапуск();
	КонецЕсли;
	
	ПраваПользователей.Сортировать("Наименование");
	
	Элементы.ПраваПользователей.ТекущаяСтрока = ПраваПользователей.НайтиСтроки(Новый Структура("Логин", НовыйОбъект.Логин))[0].ПолучитьИдентификатор();
	
	ОбновитьСтатусСопоставления(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваПользователейПравоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПраваПользователей.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Право) Тогда
		ТекущиеДанные.Пользователь = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваПользователейПравоОчистка(Элемент, СтандартнаяОбработка)
	
	Элементы.ПраваПользователей.ТекущиеДанные.Пользователь = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваПользователейПользовательПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПраваПользователей.ТекущиеДанные;
	
	Для Каждого НайденнаяСтрока Из ПраваПользователей.НайтиСтроки(Новый Структура("Пользователь", ТекущиеДанные.Пользователь)) Цикл
		Если НайденнаяСтрока <> ТекущиеДанные Тогда
			НайденнаяСтрока.Пользователь = Неопределено;
			НайденнаяСтрока.Право = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Право) Тогда
		Если ТекущиеДанные.Роль = МиграцияПриложенийКлиентСервер.РольВладелец() 
			Или ТекущиеДанные.Роль = МиграцияПриложенийКлиентСервер.РольАдминистратор() Тогда
			ТекущиеДанные.Право = МиграцияПриложенийКлиентСервер.ПравоЗапускИАдминистрирование();
		Иначе
			ТекущиеДанные.Право = МиграцияПриложенийКлиентСервер.ПравоЗапуск();
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСтатусСопоставления(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСтраниц

&НаКлиенте
Процедура ОткрытиеСтраницы(Страница)
	
	Элементы.Далее.Видимость = Истина;
	Элементы.Далее.Доступность = Истина;
	Элементы.Далее.Заголовок = НСтр("ru = 'Далее'");
	
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Отмена.Заголовок = НСтр("ru = 'Отмена'");
	
	Элементы.Назад.Видимость = Истина;
	
	НайденныйЭлемент = СтекСтраниц.НайтиПоЗначению(Страница.Имя);
	Если НайденныйЭлемент = Неопределено Тогда
		СтекСтраниц.Добавить(Страница.Имя);
	Иначе
		КоличествоПовторов = СтекСтраниц.Количество() - СтекСтраниц.Индекс(НайденныйЭлемент) - 1;
		Для НомерПовтора = 1 По КоличествоПовторов Цикл
			СтекСтраниц.Удалить(СтекСтраниц.Количество() - 1);
		КонецЦикла;
	КонецЕсли;
	ЭтоПереходНазад = НайденныйЭлемент <> Неопределено;
	
	Если Страница = Элементы.СтраницаАдресСервиса Тогда
		СтраницаАдресСервисаОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаИдентификационныеДанные Тогда
		СтраницаИдентификационныеДанныеОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаПодтверждениеРегистрации Тогда
		СтраницаПодтверждениеРегистрацииОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаВыборАбонента Тогда
		СтраницаВыборАбонентаОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаПраваПользователей Тогда
		СтраницаПраваПользователейОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаСозданиеПриложение Тогда
		СтраницаСозданиеПриложениеОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаОжидание Тогда
		СтраницаОжиданиеОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаОшибка Тогда
		СтраницаОшибкаОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаРезультат Тогда
		СтраницаРезультатОткрытие(ЭтоПереходНазад);
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Страница;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаАдресСервисаОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Миграция приложения в сервис'");
	Элементы.Назад.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаАдресСервисаДалее()
	
	Если Не ЗначениеЗаполнено(АдресСервиса) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен адрес сервиса'"), , "АдресСервиса");
		Возврат Неопределено;
	КонецЕсли;
	
	ЧастиАдреса = СтрРазделить(НРег(СокрЛП(АдресСервиса)), "/", Ложь);
	Протокол = ЧастиАдреса[0];
	Если СтрЗаканчиваетсяНа(Протокол, ":") Тогда
		ЧастиАдреса.Удалить(0);
	КонецЕсли;
	Если ЧастиАдреса.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректный адрес сервиса'"), , "АдресСервиса");
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяСервера = ЧастиАдреса[0];
	АдресСервиса = "https://" + ИмяСервера;
	
	
	Если Не СервисПоддерживаетМиграцию() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Элементы.СтраницаИдентификационныеДанные;
	
КонецФункции

&НаКлиенте
Процедура СтраницаИдентификационныеДанныеОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Аутентификация в сервисе'");
	
	Элементы.ДекорацияИдентификационныеДанные.Заголовок = СтрШаблон(НСтр("ru = 'Вход в сервис: %1'"), АдресСервиса);
	Элементы.ДекорацияРегистрация.Видимость = ЗначениеЗаполнено(АдресРегистрации);
	Элементы.ДекорацияВосстановление.Видимость = ЗначениеЗаполнено(АдресВосстановления);
	
	Элементы.СостояниеРегистрацииВСервисе.Доступность = РегистрацияРазрешена;
	
	Элементы.СтраницаИдентификационныеДанныеСтраницы.ТекущаяСтраница = 
		?(СостояниеРегистрацииВСервисе = "Зарегистрирован", 
			Элементы.СтраницаЗарегистрированныйПользователь, 
			Элементы.СтраницаРегистрация);
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаИдентификационныеДанныеДалее()
	
	Если СостояниеРегистрацииВСервисе = "Зарегистрирован" Тогда
		Возврат ВыбратьАбонента();
	КонецЕсли;
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(РегистрацияНаименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Полное имя (Ф.И.О.)""'"), , "РегистрацияНаименование", , Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Логин) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Имя(логин)""'"), , "Логин", , Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(РегистрацияЭлектроннаяПочта) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Электронная почта""'"), , "РегистрацияЭлектроннаяПочта", , Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Пароль) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Пароль""'"), , "Пароль", , Отказ);
	ИначеЕсли Пароль <> ПодтверждениеПароля Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Подтверждение пароля не совпадает с паролем'"), , "ПодтверждениеПароля", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РегистрацияВыполнена = ЗарегистрироватьсяНаСервере();
	
	Если РегистрацияВыполнена Тогда
		Возврат Элементы.СтраницаПодтверждениеРегистрации;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СтраницаПодтверждениеРегистрацииОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Подтверждение регистрации'");
	РегистрацияКодПодтверждения = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаПодтверждениеРегистрацииДалее()
	
	Если ПодтвердитьРегистрациюНаСервере(РегистрацияКодПодтверждения) Тогда
		
		СостояниеРегистрацииВСервисе = "Зарегистрирован";
		
		РегистрацияКодПодтверждения = Неопределено;
		РегистрацияНаименование = Неопределено;
		РегистрацияТелефон = Неопределено;
		РегистрацияЭлектроннаяПочта = Неопределено;
		
		Возврат ВыбратьАбонента();
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СтраницаВыборАбонентаОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Выбор абонента'");
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаВыборАбонентаДалее()
	
	Если ЗначениеЗаполнено(КодАбонента) Тогда
		Возврат Элементы.СтраницаПраваПользователей;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран абонент'"), , "КодАбонента");
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция СтраницаПраваПользователейДалее()
	
	Возврат Элементы.СтраницаСозданиеПриложение;
	
КонецФункции

&НаКлиенте
Процедура СтраницаПраваПользователейОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Права пользователей'");
	
	Если Не ЭтоПереходНазад Тогда
		ЗаполнитьПраваПользователей();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаСозданиеПриложениеДалее()
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Наименование""'"), , "Наименование", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НачатьПереход();
	
	Возврат Элементы.СтраницаОжидание;
	
КонецФункции

&НаКлиенте
Процедура СтраницаСозданиеПриложениеОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Параметры создания приложения'");
	Элементы.Далее.Заголовок = НСтр("ru = 'Начать миграцию'");
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Наименование = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаОжиданиеДалее()
	
	Задание = ЗапуститьМонопольноеЗавершение();
	
	Если ЗначениеЗаполнено(Задание) Тогда
		Текст = НСтр("ru = 'Установлен монопольный режим, не закрывайте приложение до окончания миграции.'");
		Элементы.Далее.Доступность = Ложь;
	Иначе
		Текст = НСтр("ru = 'Не удалось установить монопольный режим, необходимо завершение сеансов всех пользователей.'");
	КонецЕсли;
	
	ПоказатьПредупреждение(, Текст);
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СтраницаОжиданиеОткрытие(ЭтоПереходНазад)
	
	ПараметрыПриложения["ТехнологияСервиса.МиграцияПриложений.ФормаПереходВСервис"] = ЭтотОбъект;
	
	Заголовок = НСтр("ru = 'Выполняется миграция...'");
	
	Элементы.Далее.Видимость = ТребуетсяМонопольныйРежим;
	Элементы.Далее.Заголовок = НСтр("ru = 'Завершить миграцию'");
	Элементы.Отмена.Видимость = Истина;
	Элементы.Назад.Видимость = Ложь;
	
	Строки = Новый Массив;
	Строки.Добавить(НСтр("ru = 'Адрес сервиса'") + ": ");
	Строки.Добавить(Новый ФорматированнаяСтрока(АдресСервиса, , , , АдресСервиса));
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(СтрШаблон(НСтр("ru = 'Код абонента: %1'"), КодАбонента) + Символы.ПС);
	Строки.Добавить(СтрШаблон(НСтр("ru = 'Код приложения: %1'"), КодПриложения) + Символы.ПС);
	Строки.Добавить(НСтр("ru = 'Контакты обслуживающей организации'") + ":" + Символы.ПС);
	Строки.Добавить(Символы.Таб);
	Строки.Добавить(Символы.Таб + СтрШаблон(НСтр("ru = 'e-mail: %1'"), ОбслуживающаяОрганизацияЭлектроннаяПочта) + Символы.ПС);
	Строки.Добавить(Символы.Таб);
	Строки.Добавить(Символы.Таб + СтрШаблон(НСтр("ru = 'тел.: %1'"), ОбслуживающаяОрганизацияТелефон) + Символы.ПС);
	
	Элементы.ДекорацияИнформация.Заголовок = Новый ФорматированнаяСтрока(Строки);
	
	ПодключитьОбработчикОжидания("ОбновлениеСтатусаПерехода", 5, Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаРезультатДалее()
	
	ОчиститьСостояниеВыгрузки();
	Закрыть();
	
КонецФункции

&НаКлиенте
Процедура СтраницаРезультатОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Результат миграции'");
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Назад.Видимость = Ложь;
	
	Элементы.ДекорацияСсылка.Видимость = ЗначениеЗаполнено(АдресПриложения);
	Если ЗначениеЗаполнено(АдресПриложения) Тогда
		Элементы.ДекорацияСсылка.Заголовок = Новый ФорматированнаяСтрока(АдресПриложения, , , , АдресПриложения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаОшибкаДалее()
	
	ОчиститьСостояниеВыгрузки();
	Закрыть();
	
КонецФункции

&НаКлиенте
Процедура СтраницаОшибкаОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Ошибка миграции'");
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Назад.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция АбонентыПользователя()
	
	Возврат МиграцияПриложений.АбонентыПользователя(ЭтотОбъект);
	
КонецФункции

&НаСервере
Функция СервисПоддерживаетМиграцию()
	
	Возврат МиграцияПриложений.СервисПоддерживаетМиграцию(ИмяСервера, АдресПрограммногоИнтерфейса, АдресРегистрации, АдресВосстановления, РегистрацияРазрешена);
	
КонецФункции

&НаСервере
Процедура НачатьПереход()
	
	ДанныеПриложения = МиграцияПриложений.СоздатьПриложениеДляМиграции(ЭтотОбъект, Наименование, ЧасовойПоясСеанса(), ПраваПользователей);
	КодПриложения = ДанныеПриложения.Код;
	
	ВыгружатьНастройкиПользователей = Новый Соответствие;
	Для Каждого ПравоПользователя Из ПраваПользователей Цикл
		Если ЗначениеЗаполнено(ПравоПользователя.Пользователь) Тогда
			ВыгружатьНастройкиПользователей.Вставить(ПравоПользователя.Пользователь, ПравоПользователя.Логин);
		КонецЕсли;
	КонецЦикла;
	
	ЗавершитьМиграциюАвтоматически = ВариантЗавершенияМиграции = 0;
	
	ДанныеОбслуживающейОрганизации = МиграцияПриложений.ДанныеОбслуживающейОрганизации(ЭтотОбъект);
	
	ОбслуживающаяОрганизацияЭлектроннаяПочта = ДанныеОбслуживающейОрганизации.ЭлектроннаяПочта;
	ОбслуживающаяОрганизацияТелефон = ДанныеОбслуживающейОрганизации.Телефон;
	
	ДополнительныеСвойства = Новый Структура;
	ДополнительныеСвойства.Вставить("АдресСервиса", АдресСервиса);
	ДополнительныеСвойства.Вставить("ОбслуживающаяОрганизацияЭлектроннаяПочта", ОбслуживающаяОрганизацияЭлектроннаяПочта);
	ДополнительныеСвойства.Вставить("ОбслуживающаяОрганизацияТелефон", ОбслуживающаяОрганизацияТелефон);
	ДополнительныеСвойства.Вставить("КодАбонента", КодАбонента);
	ДополнительныеСвойства.Вставить("КодПриложения", КодПриложения);
	
	МиграцияПриложений.НачатьВыгрузку(
		ДанныеПриложения.АдресПриложения, 
		ДанныеПриложения.Логин, 
		ДанныеПриложения.Пароль, 
		ВыгружатьНастройкиПользователей, 
		ЗавершитьМиграциюАвтоматически, 
		ДополнительныеСвойства);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПереход()
	
	МиграцияПриложений.ОтменитьВыгрузку();
	ВыключитьМонопольныйРежим();
	Задание = Неопределено;
	АдресПриложения = "";
	ДатаЗавершения = ТекущаяДатаСеанса();
	Комментарий = НСтр("ru = 'Переход в сервис отменен'");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СостояниеПерехода()
	
	СостояниеПерехода = МиграцияПриложений.СостояниеВыгрузки();
	СостояниеПерехода.Вставить("ОсталосьВремени", НСтр("ru = 'Рассчитывается...'"));
	
	Если (СостояниеПерехода.Состояние = Перечисления.СостоянияМиграцииПриложения.Выполняется 
			Или СостояниеПерехода.Состояние = Перечисления.СостоянияМиграцииПриложения.ОжиданиеЗагрузки)
		И СостояниеПерехода.НомерОтправленногоСообщения >= 3 
		И СостояниеПерехода.ЗагруженоОбъектов <> 0 Тогда
		
		ОставшеесяВремя = (ТекущаяУниверсальнаяДата() - СостояниеПерехода.ДатаНачала) / СостояниеПерехода.ЗагруженоОбъектов * СостояниеПерехода.ЗагрузитьОбъектов;
		
		Если ОставшеесяВремя <= 180 Тогда
			СостояниеПерехода.ОсталосьВремени = НСтр("ru = 'Несколько минут'");
		ИначеЕсли ОставшеесяВремя <= 3600 Тогда
			СостояниеПерехода.ОсталосьВремени = СтрШаблон(НСтр("ru = '~ %1 мин.'"), Окр(ОставшеесяВремя / 60));
		Иначе
			СостояниеПерехода.ОсталосьВремени = СтрШаблон(НСтр("ru = '~ %1 ч.'"), Окр(ОставшеесяВремя / 3600, 1));
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СостояниеПерехода.ДатаНачала) Тогда
		СостояниеПерехода.ДатаНачала = МестноеВремя(СостояниеПерехода.ДатаНачала, ЧасовойПоясСеанса());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СостояниеПерехода.ДатаЗавершения) Тогда
		СостояниеПерехода.ДатаЗавершения = МестноеВремя(СостояниеПерехода.ДатаЗавершения, ЧасовойПоясСеанса());
	КонецЕсли;
	
	СостояниеПерехода.Вставить("Прогресс", 0);
	Если СостояниеПерехода.ЗагруженоОбъектов <> 0 Тогда
		СостояниеПерехода.Вставить("Прогресс", СостояниеПерехода.ЗагруженоОбъектов * 100 / (СостояниеПерехода.ЗагрузитьОбъектов + СостояниеПерехода.ЗагруженоОбъектов));
	КонецЕсли;
	
	СостояниеПерехода.Вставить("ТекстСообщенийОтправленоОбработано", СтрШаблон(НСтр("ru = '%1 / %2'"), СостояниеПерехода.НомерОтправленногоСообщения, СостояниеПерехода.НомерПринятогоСообщения));
	СостояниеПерехода.Вставить("ТекстОбъектовВыгруженоЗагружено", СтрШаблон(НСтр("ru = '%1 / %2'"), СостояниеПерехода.ВыгруженоОбъектов, СостояниеПерехода.ЗагруженоОбъектов));
	СостояниеПерехода.Вставить("ТекстОсталосьВыгрузитьЗагрузить", СтрШаблон(НСтр("ru = '%1 / %2'"), СостояниеПерехода.ИзмененоОбъектов, СостояниеПерехода.ЗагрузитьОбъектов));
	
	Возврат СостояниеПерехода;
	
КонецФункции

&НаКлиенте
Процедура ОбновлениеСтатусаПерехода()
	
	ПрошлоеТребуетсяМонопольныйРежим = ТребуетсяМонопольныйРежим;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
	Если ЗначениеЗаполнено(ДатаЗавершения) Тогда
		
		Если ЗначениеЗаполнено(Задание) Тогда
			Если ВыключитьМонопольныйРежим() Тогда
				Задание = Неопределено;
				ОтключитьОбработчикОжидания("ОбновлениеСтатусаПерехода");
				ПараметрыПриложения.Удалить("ТехнологияСервиса.МиграцияПриложений.ФормаПереходВСервис");
			КонецЕсли;
		КонецЕсли;
		
		Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ЗавершенаСОшибкой") Тогда
			НоваяСтраница = Элементы.СтраницаОшибка;
		Иначе
			НоваяСтраница = Элементы.СтраницаРезультат;
		КонецЕсли;
		
		ОткрытиеСтраницы(НоваяСтраница);
		
		Если Не Открыта() Тогда
			Открыть();
		КонецЕсли;
		
	Иначе
		
		Элементы.Далее.Видимость = ТребуетсяМонопольныйРежим;
		Если ЗначениеЗаполнено(Задание) Тогда
			Задание = ЗапуститьМонопольноеЗавершение();
		ИначеЕсли ТребуетсяМонопольныйРежим И ЗавершитьМиграциюАвтоматически Тогда
			Задание = ЗапуститьМонопольноеЗавершение();
		КонецЕсли;
		
		Если ТребуетсяМонопольныйРежим И Не ПрошлоеТребуетсяМонопольныйРежим И Не ЗавершитьМиграциюАвтоматически И Не Открыта() Тогда
			Открыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСостояниеВыгрузки()
	
	РегистрыСведений.МиграцияПриложенийСостояниеВыгрузки.СоздатьНаборЗаписей().Записать();
	//ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПраваПользователей()
	
	ПраваПользователей.Очистить();
	ОтборПользователи.Очистить();
	
	ПользователиСервиса = МиграцияПриложений.ПользователиСервиса(ЭтотОбъект);
	Для Каждого ПользовательСервиса Из ПользователиСервиса Цикл
		
		ПравоПользователя = ПраваПользователей.Добавить();
		ПравоПользователя.Логин = ПользовательСервиса.Логин;
		ПравоПользователя.Наименование = ПользовательСервиса.Наименование;
		ПравоПользователя.ЭлектроннаяПочта = ПользовательСервиса.ЭлектроннаяПочта;
		ПравоПользователя.Роль = ПользовательСервиса.Роль;
		
		// По умолчанию права имеют только владельцы абонентов.
		Если ПользовательСервиса.Роль = "Владелец" Тогда
			ПравоПользователя.Право = МиграцияПриложенийКлиентСервер.ПравоЗапускИАдминистрирование();
		КонецЕсли;
		
		Если ПользовательСервиса.Логин = Логин Тогда
			ТекущийПользовательСервиса = ПравоПользователя;
		КонецЕсли;
		
	КонецЦикла;
	
	ПраваПользователей.Сортировать("Наименование");
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустойИдентификатор", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка,
	|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ,
	|	Пользователи.Наименование КАК Наименование,
	|	ПочтовыеАдреса.Представление КАК ЭлектроннаяПочта
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи.КонтактнаяИнформация КАК ПочтовыеАдреса
	|		ПО Пользователи.Ссылка = ПочтовыеАдреса.Ссылка
	|			И (ПочтовыеАдреса.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailПользователя))
	|ГДЕ
	|	НЕ Пользователи.Служебный
	|	И НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Истина);
	Пока Выборка.Следующий() Цикл
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Выборка.ИдентификаторПользователяИБ);
		
		Если ПользовательИБ = Неопределено Или Не Пользователи.ВходВПрограммуРазрешен(ПользовательИБ) Тогда
			Продолжить;
		КонецЕсли;
		
		// Этого пользователя можно выбирать.
		ОтборПользователи.Добавить(Выборка.Ссылка);
		
		Если Выборка.Ссылка = ТекущийПользователь Тогда 
			ТекущийПользовательСервиса.Пользователь = ТекущийПользователь;
			ТекущийПользовательСервиса.Право = МиграцияПриложенийКлиентСервер.ПравоЗапускИАдминистрирование();
			Продолжить;
		КонецЕсли;
		
		ПользовательСервиса = ПодобратьПользователяСервиса(Выборка.Ссылка, ПользовательИБ.Имя, Выборка.Наименование, Выборка.ЭлектроннаяПочта);
		Если ПользовательСервиса <> Неопределено Тогда
			ПользовательСервиса.Пользователь = Выборка.Ссылка;
			Если ПользовательСервиса.Роль = МиграцияПриложенийКлиентСервер.РольВладелец() 
				Или ПользовательСервиса.Роль = МиграцияПриложенийКлиентСервер.РольАдминистратор() 
				Или ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
				ПользовательСервиса.Право = МиграцияПриложенийКлиентСервер.ПравоЗапускИАдминистрирование();
			Иначе
				ПользовательСервиса.Право = МиграцияПриложенийКлиентСервер.ПравоЗапуск();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьСтатусСопоставления(ЭтотОбъект);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПодобратьПользователяСервиса(Пользователь, Логин, Наименование, ЭлектроннаяПочта)
	
	Отборы = Новый Массив;
	Отборы.Добавить(Новый Структура("Логин", Логин));
	Если ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		Отборы.Добавить(Новый Структура("ЭлектроннаяПочта", ЭлектроннаяПочта));
		Отборы.Добавить(Новый Структура("Логин", ЭлектроннаяПочта));
	КонецЕсли;
	Отборы.Добавить(Новый Структура("Наименование", Наименование));
	
	Для Каждого Отбор Из Отборы Цикл
		НайденныеСтроки = ПраваПользователей.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() <> 1 Тогда
			Продолжить;
		КонецЕсли;
		ПользовательСервиса = НайденныеСтроки[0];
		Если ПраваПользователей.НайтиСтроки(Новый Структура("Пользователь", Пользователь)).Количество() = 0 Тогда
			Возврат ПользовательСервиса;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтатусСопоставления(Форма)
	
	ОтборПустыеСтроки = Новый Структура("Пользователь", ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
	КоличествоПустыхСтрок = Форма.ПраваПользователей.НайтиСтроки(ОтборПустыеСтроки).Количество();
	НесопоставленоПользователей = Форма.ОтборПользователи.Количество() - Форма.ПраваПользователей.Количество() + КоличествоПустыхСтрок;
	
	Если НесопоставленоПользователей > 0 Тогда
		Заголовок = СтрШаблон(НСтр("ru = 'Пользователей из базы не сопоставлено: %1'"), НесопоставленоПользователей);
	Иначе
		Заголовок = НСтр("ru = 'Все пользователи из базы сопоставлены'");
	КонецЕсли;
	
	Форма.Элементы.ДекорацияСтатусСопоставления.Заголовок = Заголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемОповещение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытьБезусловно = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьМонопольноеЗавершение()
	
	Попытка
		УстановитьМонопольныйРежим(Истина);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Отбор = Новый Структура("Ключ, Состояние", "МиграцияПриложенийВыгрузка", СостояниеФоновогоЗадания.Активно);
	ЗапущенныеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ЗапущенныеЗадания.Количество() = 0 Тогда
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(Истина);
		ФоновоеЗадание = ФоновыеЗадания.Выполнить("МиграцияПриложений.ЗаданиеВыгрузка", ПараметрыЗадания, "МиграцияПриложенийВыгрузка");
		Возврат ФоновоеЗадание.УникальныйИдентификатор;
	Иначе
		Возврат ЗапущенныеЗадания[0].УникальныйИдентификатор;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыключитьМонопольныйРежим()
	
	Попытка
		УстановитьМонопольныйРежим(Ложь);
	Исключение
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЗарегистрироватьсяНаСервере()
	
	Возврат МиграцияПриложений.Зарегистрироваться(ИмяСервера, РегистрацияНаименование, Логин, РегистрацияЭлектроннаяПочта, Пароль, РегистрацияТелефон);
	
КонецФункции

&НаСервере
Функция ПодтвердитьРегистрациюНаСервере(РегистрацияКодПодтверждения)
	
	Возврат МиграцияПриложений.ПодтвердитьРегистрацию(ИмяСервера, РегистрацияКодПодтверждения);
	
КонецФункции

&НаКлиенте
Функция ВыбратьАбонента()
	
	АбонентыПользователя = АбонентыПользователя();
	
	Если АбонентыПользователя.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Нет прав для добавления приложений абоненту.'");
	ИначеЕсли АбонентыПользователя.Количество() = 1 Тогда
		КодАбонента = АбонентыПользователя[0].Значение;
		Возврат Элементы.СтраницаПраваПользователей;
	Иначе
		Элементы.КодАбонента.СписокВыбора.Очистить();
		Для Каждого Элемент Из АбонентыПользователя Цикл
			Элементы.КодАбонента.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЦикла;
		Возврат Элементы.СтраницаВыборАбонента;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииФормы(ПриНачалеРаботыСистемы = Ложь) Экспорт
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ЗавершенаУспешно") Тогда
		НоваяСтраница = Элементы.СтраницаРезультат;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ЗавершенаСОшибкой") Тогда
		НоваяСтраница = Элементы.СтраницаОшибка;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.Выполняется")
		Или Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ОжиданиеЗагрузки") Тогда
		НоваяСтраница = Элементы.СтраницаОжидание;
	Иначе
		НоваяСтраница = Элементы.СтраницаАдресСервиса;
	КонецЕсли;
	
	ОткрытиеСтраницы(НоваяСтраница);
	
	Если ПриНачалеРаботыСистемы 
		И (ЗначениеЗаполнено(ДатаЗавершения) Или ТребуетсяМонопольныйРежим) 
		И Не Открыта() Тогда
		Открыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
